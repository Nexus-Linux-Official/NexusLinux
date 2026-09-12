#!/usr/bin/env bash
# One-shot Nexus ISO build: pure Arch Linux base -> ISO build.
#
# Usage (run from this repo, path without spaces):
#   ./build-nexus-iso.sh [profile]
#
# Default profile: "desktop". Requires makepkg + mkarchiso on the host.
set -e
set -o pipefail

cd "$(dirname "$0")"
ROOT="$(pwd)"
PROFILE="${1:-desktop}"
LOCALREPO="$ROOT/localrepo"
LOCALREPO_NAME="nexus"
CALAMARES_VERSION="3.3.12"
CALAMARES_PKGBUILD_DIR="$ROOT/.calamares-pkgbuild"

for dep in mkarchiso repo-add makepkg; do
    command -v "$dep" >/dev/null 2>&1 || { echo "ERROR: missing dependency: $dep" >&2; exit 1; }
done

# Install build dependencies FIRST (including Calamares build deps + pacman-contrib for repo-add)
echo "==> [1/4] Installing build dependencies"
sudo pacman -S --needed --noconfirm \
    archiso base-devel git pacman-contrib \
    squashfs-tools dosfstools libisoburn \
    arch-install-scripts \
    jsoncpp \
    cmake extra-cmake-modules qt6-base qt6-declarative qt6-svg \
    kconfig kcoreaddons kcrash ki18n kparts kpmcore kservice kwidgetsaddons \
    libpwquality mkinitcpio-openswap networkmanager polkit-qt6 python \
    qt6-tools yaml-cpp boost boost-libs \
    vulkan-headers

# Reinstall cmake after jsoncpp update to fix libjsoncpp.so.26 linkage
sudo pacman -S --needed --noconfirm --overwrite /usr/lib/libjsoncpp.so.26 cmake
sudo ldconfig

command -v makepkg >/dev/null 2>&1 || { echo "ERROR: makepkg not found after base-devel install" >&2; exit 1; }

# Prepare a clean local pacman repo directory.
# mkarchiso cannot "see" packages that only sit in /var/cache/pacman/pkg or on
# the host filesystem - it needs a real repo database (repo-add) that
# pacman.conf points to, containing ACTUAL .pkg.tar.zst files.
# Check for existing Calamares package BEFORE cleaning (avoid dead code).
CALAMARES_EXISTS=false
if ls "$LOCALREPO"/calamares-*.pkg.tar.zst >/dev/null 2>&1; then
    CALAMARES_EXISTS=true
fi
echo "==> Preparing local pacman repo at $LOCALREPO"
rm -rf "$LOCALREPO"
mkdir -p "$LOCALREPO"
# Restore Calamares if it existed (avoid rebuilding)
if [ "$CALAMARES_EXISTS" = true ] && ls "$CALAMARES_PKGBUILD_DIR"/calamares-*.pkg.tar.zst >/dev/null 2>&1; then
    cp -f "$CALAMARES_PKGBUILD_DIR"/calamares-*.pkg.tar.zst "$LOCALREPO/"
    echo "==> Calamares package restored from previous build"
fi

# ---------------------------------------------------------------------------
# Build Calamares AS A PACKAGE (not "sudo make install" onto the host).
# mkarchiso builds the ISO in its own clean chroot and only knows about
# packages available via pacman repos - it does not care what is installed
# on the host machine. So Calamares must become a real .pkg.tar.zst that we
# add to our local repo, exactly like nexus-branding etc.
# ---------------------------------------------------------------------------
build_calamares_package() {
    echo "==> [2/4] Packaging Calamares $CALAMARES_VERSION"
    rm -rf "$CALAMARES_PKGBUILD_DIR"
    mkdir -p "$CALAMARES_PKGBUILD_DIR"
    cat > "$CALAMARES_PKGBUILD_DIR/PKGBUILD" <<EOF
pkgname=calamares
pkgver=${CALAMARES_VERSION}
pkgrel=1
pkgdesc="Distribution-independent installer framework (Nexus trimmed build)"
arch=('x86_64')
url="https://calamares.io"
license=('GPL3')
depends=('qt6-base' 'qt6-declarative' 'qt6-svg' 'kconfig' 'kcoreaddons' 'kcrash'
         'ki18n' 'kparts' 'kpmcore' 'kservice' 'kwidgetsaddons' 'libpwquality'
         'polkit-qt6' 'yaml-cpp' 'boost-libs' 'python')
makedepends=('cmake' 'extra-cmake-modules' 'qt6-tools' 'boost' 'jsoncpp')
source=("https://codeberg.org/Calamares/calamares/archive/v\${pkgver}.tar.gz")
sha256sums=('c7e635a2a0bed0078a50b8deea310eb2c09bf9d807bbeb4c8bcda4f85771fc7c')


build() {
  cd "\$srcdir/calamares"
  mkdir -p build && cd build
  cmake .. \\
    -DCMAKE_INSTALL_PREFIX=/usr \\
    -DCMAKE_BUILD_TYPE=Release \\
    -DINSTALL_CONFIG=ON \\
    -DSKIP_MODULES="webview interactiveterminal initramfs initramfscfg \\
        partition rawfs mount welcomeq license keyboard users usersq locale \\
        networkcfg displaymanager bootloader grub grubcfg efi_bootloader \\
        services-openrc services-systemd fstab fsck keyboardq summaryq"
  make
}


package() {
  cd "\$srcdir/calamares/build"
  make DESTDIR="\$pkgdir" install
}
EOF
    ( cd "$CALAMARES_PKGBUILD_DIR" && makepkg -sf --noconfirm )
    cp -f "$CALAMARES_PKGBUILD_DIR"/calamares-*.pkg.tar.zst "$LOCALREPO/"
}

if [ "$CALAMARES_EXISTS" = true ]; then
    echo "==> [2/4] Calamares package already in localrepo (restored), skipping rebuild"
else
    build_calamares_package
fi

# Build local Nexus packages (branding, wallpapers, keyring, calamares config)
echo "==> [3/4] Building local Nexus packages"
for pkg in nexus-branding nexus-wallpapers nexus-keyring nexus-calamares; do
    if [ -d "$ROOT/localpkgs/$pkg" ]; then
        echo "  building $pkg"
        ( cd "$ROOT/localpkgs/$pkg" && makepkg -sf --noconfirm )
        cp -f "$ROOT/localpkgs/$pkg"/*.pkg.tar.zst "$LOCALREPO/"
    fi
done

# Build the repo database so pacman/mkarchiso can resolve these as install targets
echo "==> Building local repo database ($LOCALREPO_NAME.db.tar.gz)"
( cd "$LOCALREPO" && repo-add --new "$LOCALREPO_NAME.db.tar.gz" ./*.pkg.tar.zst )

# Prepare a temp pacman.conf with [nexus] repo for the build.
# The committed archiso/pacman.conf intentionally has NO [nexus] section (see comment at EOF).
# We generate a temp file and let util-iso.sh copy it to work_dir, avoiding dirty working tree.
PACMAN_CONF_SRC="$ROOT/archiso/pacman.conf"
if [ ! -f "$PACMAN_CONF_SRC" ]; then
    echo "ERROR: $PACMAN_CONF_SRC not found, cannot create [nexus] repo config." >&2
    exit 1
fi
TMP_PACMAN_CONF="$(mktemp)"
{
    echo "[$LOCALREPO_NAME]"
    echo "SigLevel = Optional TrustAll"
    echo "Server = file://$LOCALREPO"
    echo
    cat "$PACMAN_CONF_SRC"
} > "$TMP_PACMAN_CONF"
export NEXUS_TMP_PACMAN_CONF="$TMP_PACMAN_CONF"
echo "==> Prepared temp pacman.conf with [$LOCALREPO_NAME] repo at $TMP_PACMAN_CONF"

echo "==> [4/4] Building ISO (profile: $PROFILE)"

# Relocate any stray calamares module copies to staging path
CALAMARES_CONFLICT="$ROOT/archiso/airootfs/etc/calamares/modules"
CALAMARES_STAGE="$ROOT/archiso/airootfs/usr/share/nexus-calamares/modules"
for _f in netinstall.yaml packagechooser_desktop.conf; do
    if [ -f "$CALAMARES_CONFLICT/$_f" ]; then
        echo "    -> relocating $_f to $CALAMARES_STAGE"
        mv -f "$CALAMARES_CONFLICT/$_f" "$CALAMARES_STAGE/$_f"
    fi
done

./buildiso.sh -p "$PROFILE" -v 2>&1 | tee "$ROOT/build.log"

echo "==> Release artifacts (.sig / SHA256SUMS / .img / pkgs.txt)"
ISO_PATH="$(find "$ROOT/out/$PROFILE" -maxdepth 1 -name '*.iso' -print -quit 2>/dev/null)"
if [ -n "$ISO_PATH" ]; then
    ( cd "$(dirname "$ISO_PATH")" && sha256sum "$(basename "$ISO_PATH")" > SHA256SUMS )
    cp -f "$ISO_PATH" "${ISO_PATH%.iso}.img"
    # Robust pkgs.txt generation: use Python YAML parser if available, fallback to grep
    if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" 2>/dev/null; then
        python3 << 'PY' > "$ROOT/out/$PROFILE/pkgs.txt"
import yaml, pathlib, re
pkgs = set()
# Parse netinstall.yaml properly
try:
    data = yaml.safe_load(open(f"{pathlib.Path.cwd()}/archiso/airootfs/usr/share/nexus-calamares/modules/netinstall.yaml"))
    def collect(obj):
        if isinstance(obj, dict):
            for k, v in obj.items():
                if k == "packages" and isinstance(v, list):
                    for p in v:
                        if isinstance(p, str):
                            pkgs.add(p.strip())
                else:
                    collect(v)
        elif isinstance(obj, list):
            for item in obj:
                collect(item)
    collect(data)
except Exception as e:
    # Fallback to grep if YAML parsing fails
    import subprocess, shlex
    try:
        out = subprocess.check_output(["grep", "-rh", r"^\s*-\s*[a-z0-9@._+-]", "archiso/airootfs/usr/share/nexus-calamares/modules/netinstall.yaml"], text=True)
        for line in out.splitlines():
            m = re.match(r"^\s*-\s*([a-z0-9@._+-]+)", line)
            if m:
                pkgs.add(m.group(1))
    except:
        pass
# Add base packages
try:
    for line in open("archiso/packages.x86_64"):
        line=line.strip()
        if line and not line.startswith("#"):
            pkgs.add(line)
except:
    pass
for p in sorted(pkgs):
    print(p)
PY
    else
        # Fallback: legacy grep method
        {
            grep -rh '^\s*-\s*[a-z0-9@._+-]' "$ROOT/archiso/airootfs/usr/share/nexus-calamares/modules/netinstall.yaml" | sed 's/^\s*-\s*//'
            cat "$ROOT/archiso/packages.x86_64" 2>/dev/null || true
        } | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$' | sort -u > "$ROOT/out/$PROFILE/pkgs.txt"
    fi
    echo "    - ISO:        $ISO_PATH"
    echo "    - SHA256:     $ROOT/out/$PROFILE/SHA256SUMS"
    echo "    - USB image:  ${ISO_PATH%.iso}.img (dd to USB)"
    echo "    - Package list: $ROOT/out/$PROFILE/pkgs.txt"
    echo "==> Done."
    echo "    Build log:  $ROOT/build.log"
else
    echo "    ERROR: out/$PROFILE/*.iso not found (build may have failed)" >&2
    echo "    Build log:  $ROOT/build.log" >&2
    exit 1
fi