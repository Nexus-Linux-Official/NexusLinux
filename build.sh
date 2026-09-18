#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/cahit/Projeler/nexus-live"
LOCALPKGS="$ROOT/localpkgs"
LOCALREPO="$ROOT/localrepo"

echo "=== [1/5] Rust workspace already fixed (skip) ==="
# Manual fixes already applied, skip sed patching

echo "=== [2/5] Building nexus-rust-tools ==="
cd "$LOCALPKGS/rust-tools"
rm -rf pkg src
makepkg -f --noconfirm

echo "=== [3/5] Building other local packages ==="
for pkg in nexus-branding nexus-wallpapers nexus-keyring nexus-kde-settings; do
    if [ -d "$LOCALPKGS/$pkg" ]; then
        cd "$LOCALPKGS/$pkg"
        rm -rf pkg src 2>/dev/null || true
        rm -f *.pkg.tar.zst 2>/dev/null || true
        makepkg -f --noconfirm
    fi
done

echo "=== [4/5] Copying packages to local repo ==="
cp "$LOCALPKGS"/rust-tools/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-branding/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-wallpapers/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-keyring/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
cp "$LOCALPKGS"/nexus-kde-settings/*.pkg.tar.zst "$LOCALREPO"/ 2>/dev/null || true
ls -lh "$LOCALREPO"/*.pkg.tar.zst

echo "=== [4/5] Rebuilding local repo database ==="
cd "$LOCALREPO"
repo-add nexus.db.tar.gz *.pkg.tar.zst

echo "=== [5/5] Building ISO ==="
cd "$ROOT"
sudo rm -rf build
sudo mkarchiso -v -w build -o out archiso

echo "=== DONE ==="
echo "ISO output: $ROOT/out/desktop/"
ls -lh "$ROOT/out/desktop/" 2>/dev/null || ls -lh out/*.iso 2>/dev/null || true