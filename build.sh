#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/cahit/Projeler/nexus-live"
LOCALPKGS="$ROOT/localpkgs"
LOCALREPO="$ROOT/localrepo"

echo "=== [1/6] Rust workspace already fixed (skip) ==="
# Manual fixes already applied, skip sed patching

echo "=== [2/6] Building nexus-rust-tools ==="
cd "$LOCALPKGS/rust-tools"
rm -rf pkg src
makepkg -f --noconfirm

echo "=== [3/6] Building other local packages ==="
for pkg in nexus-branding nexus-wallpapers nexus-keyring nexus-calamares nexus-kde-settings; do
    if [ -d "$LOCALPKGS/$pkg" ]; then
        cd "$LOCALPKGS/$pkg"
        rm -rf pkg src 2>/dev/null || true
        rm -f *.pkg.tar.zst 2>/dev/null || true
        makepkg -f --noconfirm
    fi
done
# Calamares from AUR build dir if exists, otherwise skip (already in localrepo)
if [ -d "$ROOT/.calamares-pkgbuild" ]; then
    echo ">>> Calamares package already in localrepo, skipping rebuild"
fi

echo "=== [4/6] Copying packages to local repo ==="
cp "$LOCALPKGS"/rust-tools/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-branding/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-wallpapers/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-keyring/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-calamares/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-kde-settings/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$ROOT"/.calamares-pkgbuild/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$ROOT"/.calamares-pkgbuild/pkg/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
ls -lh "$LOCALREPO"/*.pkg.tar.zst

echo "=== [5/6] Rebuilding local repo database ==="
cd "$LOCALREPO"
repo-add nexus.db.tar.gz *.pkg.tar.zst
pacman -Sy || true

echo "=== [6/6] Building ISO ==="
cd "$ROOT"
sudo rm -rf build
sudo mkarchiso -v -w build -o out archiso

echo "=== DONE ==="
echo "ISO output: $ROOT/out/desktop/"
ls -lh "$ROOT/out/desktop/" 2>/dev/null || ls -lh out/*.iso 2>/dev/null || true
