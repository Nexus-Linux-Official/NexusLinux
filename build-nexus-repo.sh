#!/usr/bin/env bash
# Builds all Nexus fork packages in localpkgs/ into a local repository and
# optionally wires them into the ISO build (netinstall.yaml + pacman.conf).
#
# Run on the build host (requires pacman/makepkg, NOT in the sandbox):
#   ./build-nexus-repo.sh               # build + create local repo
#   ./build-nexus-repo.sh --apply-swap  # also apply swap in the profile
#
# The swap should only be applied once every nexus-* package actually builds.
#
# Notes:
#  - nexus-settings pulls the upstream settings git tag over a *signed* source;
#    import the upstream PGP keys first (gpg --recv-keys E8B9AA39F054E30E8290D492C3C4820857F654FE B1B70BB1CD56047DEF31DE2EB62C3D10C54D5DA9).
#  - nexus-calamares compiles Calamares from source and needs the Qt6/KDE
#    build dependencies; this is the slowest package in the set.
set -e
set -o pipefail

cd "$(dirname "$0")"
ROOT="$(pwd)"
REPO="$ROOT/localpkgs/repo"
PKGS="$ROOT/localpkgs"
APPLY_SWAP="${1:---build-only}"

[ "$APPLY_SWAP" = "--apply-swap" ] && APPLY_SWAP=1 || APPLY_SWAP=0

# Nexus package signing. Every package and the repository database are signed
# with the Nexus master key (see localpkgs/nexus-keyring). makepkg --sign and
# repo-add -s read GPGKEY + GNUPGHOME. Override via NEXUS_GPGKEY /
# NEXUS_GNUPGHOME if the key is restored somewhere else.
export GPGKEY="${NEXUS_GPGKEY:-F4C57604C90E90CD6AB3633F2AA4846E14CBE512}"
export GNUPGHOME="${NEXUS_GNUPGHOME:-$ROOT/localpkgs/nexus-keyring/gnupg}"

# The master key may or may not be passphrase-protected (see gen-nexus-keyring.sh).
# If passphrase-protected, unlock it once for this build by presetting the
# passphrase into gpg-agent, so makepkg --sign and repo-add -s stay non-interactive.
# Provide the passphrase via NEXUS_KEY_PASSPHRASE (secrets manager / CI),
# or it is prompted for. Empty passphrase (key without protection) skips preset.
if [ -z "${NEXUS_KEY_PASSPHRASE+x}" ]; then
    if [ -t 0 ]; then
        read -r -s -p "Nexus signing key passphrase (enter for no passphrase): " NEXUS_KEY_PASSPHRASE; echo
    else
        echo "WARNING: NEXUS_KEY_PASSPHRASE not set, assuming passphrase-less key" >&2
        NEXUS_KEY_PASSPHRASE=""
    fi
fi
if [ -n "${NEXUS_KEY_PASSPHRASE:-}" ]; then
    _keygrip="$(gpg --homedir "$GNUPGHOME" --with-colons --with-keygrip --list-secret-keys "$GPGKEY" 2>/dev/null \
        | awk -F: '$1=="grp" {print $10; exit}')"
    if [ -n "$_keygrip" ]; then
        # allow-preset-passphrase lets a non-interactive process cache the
        # passphrase; the agent restarts to pick up the setting.
        grep -q '^allow-preset-passphrase$' "$GNUPGHOME/gpg-agent.conf" 2>/dev/null \
            || printf 'allow-preset-passphrase\n' >> "$GNUPGHOME/gpg-agent.conf"
        chmod 600 "$GNUPGHOME/gpg-agent.conf"
        gpgconf --homedir "$GNUPGHOME" --kill gpg-agent 2>/dev/null || true
        # Avoid logging passphrase by using gpg-preset-passphrase directly
        printf '%s' "$NEXUS_KEY_PASSPHRASE" | gpg-preset-passphrase --preset "$_keygrip" 2>/dev/null \
            || printf '%s' "$NEXUS_KEY_PASSPHRASE" | gpg-connect-agent --homedir "$GNUPGHOME" /bye >/dev/null 2>&1 \
            || echo "WARNING: passphrase gpg-agent'a preset edilemedi (imzalama isteyebilir)" >&2
    else
        echo "WARNING: GPGKEY ($GPGKEY) icin keygrip bulunamadi; imzalama interaktif olabilir" >&2
    fi
    unset _keygrip NEXUS_KEY_PASSPHRASE
fi

# nexus-settings fetches the upstream settings git tag over a *signed* source.
# makepkg verifies that signature with $GNUPGHOME (the Nexus keyring above),
# NOT with the default ~/.gnupg, so the upstream signing keys must live here
# or the PGP check fails with "bilinmeyen kamu anahtari". The same applies to
# nexus-zsh-config, nexus-kernel-manager, nexus-packageinstaller (Vladislav)
# and nexus-handheld (Peter, Vladislav, Eric).
# Fetch each upstream signing key into $GNUPGHOME and surface failures instead
# of swallowing them: a missing key silently breaks the PGP verification of the
# signed sources below, so each failure is reported loudly.
_UPSTREAM_KEYS=(
    E8B9AA39F054E30E8290D492C3C4820857F654FE  # Peter Jung (CachyOS)
    B1B70BB1CD56047DEF31DE2EB62C3D10C54D5DA9  # Vladislav Nepogodin (CachyOS)
    E18447AC260021D31F3FF6C4C8A2A4774B8B63C4  # Vladislav Nepogodin (nexus-packageinstaller, nexus-handheld, nexus-settings)
)
for _key in "${_UPSTREAM_KEYS[@]}"; do
    gpg --batch --no-tty --recv-keys "$_key" >/dev/null 2>&1 \
        || echo "WARNING: PGP key not found: $_key (signed source verification may fail)" >&2
done

mkdir -p "$REPO"
: > "$REPO/.build-nexus-repo.log"

echo "==> Building Nexus fork packages"
# Explicit build order: nexus-wallpapers must be built before nexus-kde-settings,
# which depends on it. Package directories not listed here are still built,
# after the listed ones.
BUILD_ORDER=(
    nexus-wallpapers
    nexus-kde-settings
    nexus-calamares
)
PACKAGE_LIST=("${BUILD_ORDER[@]}")
for pkgdir in "$PKGS"/*/; do
    name="$(basename "$pkgdir")"
    [ "$name" = "repo" ] && continue
    [ -f "$pkgdir/PKGBUILD" ] || continue
    case " ${BUILD_ORDER[*]} " in *" $name "*) continue ;; esac
    PACKAGE_LIST+=("$name")
done
for name in "${PACKAGE_LIST[@]}"; do
    pkgdir="$PKGS/$name"
    echo "  building $name"
    # Retry transient network failures (large git clones). Stream to the
    # terminal too, so makepkg sudo prompts stay visible. Flags:
    #   -d  skip dependency checks. build-nexus-iso.sh step [2/5] already
    #       installs every build/makedepends; runtime depends between fork
    #       packages (nexus-kde-settings -> nexus-wallpapers) are not on the
    #       host and must not be synced via pacman.
    #   -f  force rebuild (do not skip already-built packages).
    #   --sign  sign the package with the Nexus master key (GPGKEY/GNUPGHOME above).
    built=0
    for attempt in 1 2 3; do
        # makepkg refuses to run as root. In CI/containers we run as root, so
        # when BUILD_USER is set, make the package dir writable and run makepkg
        # as that (non-root) user. GNUPGHOME must be readable by them too.
        if [ -n "${BUILD_USER:-}" ] && [ "$(id -u)" = 0 ]; then
            chown -R "${BUILD_USER}:${BUILD_USER}" "$pkgdir" 2>/dev/null || true
            chown -R "${BUILD_USER}:${BUILD_USER}" "$GNUPGHOME" 2>/dev/null || true
            cmd=(runuser -u "$BUILD_USER" -- makepkg -df --sign)
        else
            cmd=(makepkg -df --sign)
        fi
        if ( cd "$pkgdir" && "${cmd[@]}" ) 2>&1 | tee -a "$REPO/.build-nexus-repo.log"; then
            built=1
            break
        fi
        [ "$attempt" -lt 3 ] && { echo "  $name denemesi $attempt/3 basarisiz oldu, tekrar deneniyor..."; sleep 5; }
    done
    if [ "$built" -eq 0 ]; then
        echo "ERROR: build of $name failed (cikti yukarida)" >&2
        exit 1
    fi
done

PKGFILES="$(find "$PKGS" -maxdepth 2 -name '*.pkg.tar.zst' 2>/dev/null)"
if [ -z "$PKGFILES" ]; then
    echo "ERROR: no packages were built" >&2
    exit 1
fi

echo "==> Populating local repository"
cd "$REPO"

# Copy all built packages (both in pkgdir and pkg/ subdir)
find "$PKGS" -mindepth 2 -maxdepth 2 -name '*.pkg.tar.zst' ! -path "$PKGS/repo/*" -print0 2>/dev/null | xargs -0 -I{} cp -f {} "$REPO/"
find "$PKGS" -mindepth 2 -maxdepth 2 -name '*.pkg.tar.zst.sig' ! -path "$PKGS/repo/*" -print0 2>/dev/null | xargs -0 -I{} cp -f {} "$REPO/"
ls -lh *.pkg.tar.zst

# Copy calamares from .calamares-pkgbuild if not already built in localpkgs
if [ -d "$ROOT/.calamares-pkgbuild" ]; then
    cp -f "$ROOT/.calamares-pkgbuild"/*.pkg.tar.zst . 2>/dev/null || true
    cp -f "$ROOT/.calamares-pkgbuild"/pkg/*.pkg.tar.zst . 2>/dev/null || true
fi

# Rebuild repo database
echo ">>> Rebuilding repo database..."
repo-add -q -s -k "$GPGKEY" nexus.db.tar.gz *.pkg.tar.zst

echo "==> Local repo ready: $REPO"
ls -la "$REPO"/*.pkg.tar.zst