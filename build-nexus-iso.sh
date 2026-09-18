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

for dep in mkarchiso repo-add makepkg; do
    command -v "$dep" >/dev/null 2>&1 || { echo "ERROR: missing dependency: $dep" >&2; exit 1; }
done

# Install build dependencies FIRST
echo "==> [1/3] Installing build dependencies"
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
echo "==> Preparing local pacman repo at $LOCALREPO"
rm -rf "$LOCALREPO"
mkdir -p "$LOCALREPO"

# Build local Nexus packages (branding, wallpapers, keyring, kde-settings, calamares)
echo "==> [2/3] Building local Nexus packages"
for pkg in nexus-branding nexus-wallpapers nexus-keyring nexus-kde-settings nexus-calamares; do
    if [ -d "$ROOT/localpkgs/$pkg" ]; then
        echo "  building $pkg"
        ( cd "$ROOT/localpkgs/$pkg" && makepkg -sf --noconfirm )
        cp -f "$ROOT/localpkgs/$pkg"/*.pkg.tar.zst "$LOCALREPO/"
    fi
done

# Build the repo database so pacman/mkarchiso can resolve these as install targets
echo "==> Building local repo database ($LOCALREPO_NAME.db.tar.gz)"
( cd "$LOCALREPO" && repo-add --new "$LOCALREPO_NAME.db.tar.gz" ./*.pkg.tar.zst )

# Build nexus-calamares from .calamares-pkgbuild if available
if [ -d "$ROOT/.calamares-pkgbuild" ]; then
    echo "==> Building nexus-calamares from source"
    if [ -d "$ROOT/.calamares-pkgbuild/calamares" ]; then
        ( cd "$ROOT/.calamares-pkgbuild/calamares" && makepkg -sf --noconfirm )
    fi
    cp -f "$ROOT/.calamares-pkgbuild"/*.pkg.tar.zst "$LOCALREPO/" 2>/dev/null || true
    cp -f "$ROOT/.calamares-pkgbuild"/pkg/*.pkg.tar.zst "$LOCALREPO/" 2>/dev/null || true
fi

# Rebuild repo database after adding calamares
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

echo "==> [3/3] Building ISO (profile: $PROFILE)"

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
# Parse packages from the package lists
for pkg_file in ["archiso/packages.x86_64", "archiso/packages_desktop.x86_64", "archiso/packages_minimal.x86_64"]:
    try:
        for line in open(pkg_file):
            line=line.strip()
            if line and not line.startswith("#"):
                pkgs.add(line)
    except:
        pass
for p in sorted(pkgs):
    print(p)
PY
    else
        # Fallback: simple grep method
        cat "$ROOT/archiso/packages.x86_64" "$ROOT/archiso/packages_desktop.x86_64" "$ROOT/archiso/packages_minimal.x86_64" 2>/dev/null | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$' | grep -v '^#' | sort -u > "$ROOT/out/$PROFILE/pkgs.txt"
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