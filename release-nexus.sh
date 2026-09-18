#!/usr/bin/env bash
# Publishes the Nexus package repository and/or an ISO to GitHub Releases.
#
# Nexus has no dedicated package mirror yet, so GitHub Releases doubles as
# the package server: pacman's [nexus] Server points at
#   https://github.com/nexuslinux-os/NexusLinux/releases/latest/download/
# and every file published here is reachable under that URL (nexus.db,
# nexus.files, *.pkg.tar.zst, ...).
#
# Usage (run on the build host, requires gh + gpg):
#   ./release-nexus.sh repo                          # publish localpkgs/repo as a new release
#   ./release-nexus.sh iso out/desktop/nexus.iso     # sign + checksum + upload an ISO
#
# Repo releases must be created BEFORE the ISO is built with NEXUS_SWAP=1,
# because the live installer resolves nexus-* packages from GitHub.
set -euo pipefail

cd "$(dirname "$0")"
ROOT="$(pwd)"
REPO="$ROOT/localpkgs/repo"
GIT_REPO="${NEXUS_GIT_REPO:-nexuslinux-os/NexusLinux}"
TAG_PREFIX="${NEXUS_TAG_PREFIX:-nexus-v}"
export GPGKEY="${NEXUS_GPGKEY:-F4C57604C90E90CD6AB3633F2AA4846E14CBE512}"
export GNUPGHOME="${NEXUS_GNUPGHOME:-$ROOT/localpkgs/nexus-keyring/gnupg}"

for dep in gh gpg repo-add; do
    command -v "$dep" >/dev/null 2>&1 || { echo "ERROR: missing dependency: $dep" >&2; exit 1; }
done

# Validate the Nexus master key is usable for signing (non-interactive).
if ! gpg --batch --no-tty --list-keys "$GPGKEY" >/dev/null 2>&1; then
    echo "ERROR: Nexus master key ($GPGKEY) not found in $GNUPGHOME" >&2
    echo "      Key may not have been restored (see localpkgs/nexus-keyring)." >&2
    exit 1
fi

new_tag() {
    local tag
    tag="${TAG_PREFIX}$(date -u +%Y.%m.%d)"
    local i=1
    while gh release view "$tag" --repo "$GIT_REPO" >/dev/null 2>&1; do
        tag="${TAG_PREFIX}$(date -u +%Y.%m.%d)-$i"
        i=$((i + 1))
    done
    echo "$tag"
}

publish_repo() {
    echo "==> Publishing repo: $GIT_REPO"
    [ -f "$REPO/nexus.db.tar.zst" ] || { echo "ERROR: $REPO/nexus.db.tar.zst not found. Run ./build-nexus-repo.sh first." >&2; exit 1; }

    local work
    work="$(mktemp -d)"
    trap 'rm -rf "$work"' RETURN

    # repo-add produces .db/.files symlinks; GitHub cannot store symlinks, so
    # publish real copies under the exact names pacman will request.
    for name in nexus.db nexus.db.sig nexus.files nexus.files.sig; do
        case "$name" in
            nexus.db)      [ -e "$REPO/nexus.db.tar.zst" ] && cp -f "$REPO/nexus.db.tar.zst"     "$work/nexus.db" || { echo "ERROR: $REPO/nexus.db.tar.zst missing" >&2; exit 1; } ;;
            nexus.db.sig)  if [ -e "$REPO/nexus.db.tar.zst.sig" ]; then cp -f "$REPO/nexus.db.tar.zst.sig" "$work/nexus.db.sig"; else echo "WARNING: $REPO/nexus.db.tar.zst.sig missing - repo will be unsigned (SigLevel=Required will fail)" >&2; fi ;;
            nexus.files)   [ -e "$REPO/nexus.files.tar.zst" ] && cp -f "$REPO/nexus.files.tar.zst"   "$work/nexus.files" || { echo "ERROR: $REPO/nexus.files.tar.zst missing" >&2; exit 1; } ;;
            nexus.files.sig) if [ -e "$REPO/nexus.files.tar.zst.sig" ]; then cp -f "$REPO/nexus.files.tar.zst.sig" "$work/nexus.files.sig"; else echo "WARNING: $REPO/nexus.files.tar.zst.sig missing - repo will be unsigned" >&2; fi ;;
        esac
    done

    local tag notes
    tag="$(new_tag)"
    notes="Nexus repository $(date -u +%Y-%m-%d)

[nexus] repo icin:  Server = https://github.com/$GIT_REPO/releases/latest/download/
Guncelleme:         sudo pacman -Syu"
    echo "==> New release: $tag"
    shopt -s nullglob
    pkg_files=("$REPO"/*.pkg.tar.zst)
    sig_files=("$REPO"/*.pkg.tar.zst.sig)
    if [ ${#pkg_files[@]} -eq 0 ]; then
        echo "ERROR: No packages found in $REPO" >&2
        exit 1
    fi
    gh release create "$tag" \
        --repo "$GIT_REPO" \
        --title "Nexus repository $tag" \
        --notes "$notes" \
        "$work/nexus.db" "$work/nexus.db.sig" "$work/nexus.files" "$work/nexus.files.sig" \
        "${pkg_files[@]}" "${sig_files[@]}"
    shopt -u nullglob
    echo "==> Done: https://github.com/$GIT_REPO/releases/tag/$tag"
    echo "    Next: ./release-nexus.sh iso out/<profile>/<name>.iso"
}

publish_iso() {
    local iso="$1"
    [ -f "$iso" ] || { echo "ERROR: ISO not found: $iso" >&2; exit 1; }

    local work
    work="$(mktemp -d)"
    trap 'rm -rf "$work"' RETURN

    echo "==> ISO artefaktlari: $iso"

    # Signing + checksums next to the ISO itself.
    gpg --batch --yes --armor --detach-sign --output "$iso.sig" "$iso" 2>/dev/null \
        || gpg --batch --yes --detach-sign --output "$iso.sig" "$iso"
    ( cd "$(dirname "$iso")" && sha256sum "$(basename "$iso")" > "$(dirname "$iso")/SHA256SUMS" )

    # The ISO is already hybrid/dd-able, so no separate .img copy is published.

    # pkgs.txt: profile packages + netinstall selection, sorted, deduped.
    {
        cat archiso/packages.x86_64 2>/dev/null || true
        for f in archiso/*/packages.x86_64; do [ -f "$f" ] && cat "$f"; done 2>/dev/null || true
    } | grep -v '^\s*#' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$' | sort -u > "$(dirname "$iso")/pkgs.txt"

    local tag notes
    tag="$(new_tag)"
    notes="Nexus Linux ISO $(date -u +%Y-%m-%d)

    ISO:        $(basename "$iso")
    SHA256:     $(cd "$(dirname "$iso")" && awk '{print $1}' SHA256SUMS)
    USB yazma:  sudo dd if=$(basename "$iso") of=/dev/sdX bs=4M status=progress conv=fsync"
    echo "==> Yeni release: $tag"
    gh release create "$tag" \
        --repo "$GIT_REPO" \
        --title "Nexus Linux $tag" \
        --notes "$notes" \
        "$iso" "$iso.sig" "$(dirname "$iso")/SHA256SUMS" \
        "$(dirname "$iso")/pkgs.txt"
    echo "==> Finished: https://github.com/$GIT_REPO/releases/tag/$tag"
}

case "${1:-}" in
    repo) publish_repo ;;
    iso)  [ $# -ge 2 ] || { echo "Usage: $0 iso <file.iso>" >&2; exit 1; }; publish_iso "$2" ;;
    *) echo "Usage: $0 {repo|iso <file.iso>}" >&2; exit 1 ;;
esac
