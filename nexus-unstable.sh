#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/cahit/Projeler/nexus-live"
LOCALPKGS="$ROOT/localpkgs"
LOCALREPO="$ROOT/localrepo"
BUILD_DATE=$(date +%Y.%m.%d)
ISO_NAME="nexus-unstable-${BUILD_DATE}-x86_64.iso"

echo "=== Nexus Linux Unstable ISO Builder ==="
echo "ISO: $ISO_NAME"
echo ""

# Function to build a package without installing (avoids file conflicts), returns 0 on success
build_pkg() {
    local pkg_dir="$1"
    local pkg_name="$2"
    echo ">>> Building $pkg_name..."
    if [ -d "$pkg_dir" ]; then
        cd "$pkg_dir"
        rm -rf pkg src 2>/dev/null || true
        if makepkg --noconfirm 2>&1 | tail -20; then
            echo "✓ $pkg_name built successfully"
            return 0
        else
            echo "✗ $pkg_name FAILED"
            return 1
        fi
    else
        echo "✗ $pkg_name directory not found"
        return 1
    fi
}

# Phase 1: Build all local packages
echo "=== Phase 1: Building local packages ==="

# Build nexus-rust-tools (may fail but continue)
RUST_OK=0
if build_pkg "$LOCALPKGS/rust-tools" "nexus-rust-tools"; then
    RUST_OK=1
else
    echo ">>> nexus-rust-tools failed, will exclude from ISO"
fi

# Build other packages (continue on failure)
for pkg in nexus-branding nexus-wallpapers nexus-keyring nexus-calamares nexus-kde-settings; do
    build_pkg "$LOCALPKGS/$pkg" "$pkg" || echo ">>> $pkg build failed, continuing..."
done

# Calamares already built in localrepo, skip install-requiring build
echo ">>> Calamares package already in localrepo, skipping"

# Phase 2: Copy packages to local repo
echo ""
echo "=== Phase 2: Updating local repository ==="
cd "$LOCALREPO"

# Copy all built packages (both in dir and in pkg subdir for split packages)
cp "$LOCALPKGS"/rust-tools/*.pkg.tar.zst . 2>/dev/null || true
cp "$LOCALPKGS"/rust-tools/pkg/*.pkg.tar.zst . 2>/dev/null || true
cp "$LOCALPKGS"/nexus-branding/*.pkg.tar.zst . 2>/dev/null || true
cp "$LOCALPKGS"/nexus-wallpapers/*.pkg.tar.zst . 2>/dev/null || true
cp "$LOCALPKGS"/nexus-keyring/*.pkg.tar.zst . 2>/dev/null || true
cp "$LOCALPKGS"/nexus-calamares/*.pkg.tar.zst . 2>/dev/null || true
cp "$LOCALPKGS"/nexus-kde-settings/*.pkg.tar.zst . 2>/dev/null || true
cp "$ROOT"/.calamares-pkgbuild/*.pkg.tar.zst . 2>/dev/null || true
cp "$ROOT"/.calamares-pkgbuild/pkg/*.pkg.tar.zst . 2>/dev/null || true
ls -lh *.pkg.tar.zst | awk '{print $9, $5}'

# Rebuild repo database
echo ">>> Rebuilding repo database..."
repo-add nexus.db.tar.gz *.pkg.tar.zst
pacman -Sy || true

# Phase 3: Modify package list for ISO
echo ""
echo "=== Phase 3: Preparing package list ==="
PACKAGES_FILE="$ROOT/archiso/packages.x86_64"

# Backup original
cp "$PACKAGES_FILE" "$PACKAGES_FILE.bak" 2>/dev/null || true
# Create modified package list
if [ $RUST_OK -eq 1 ]; then
    echo ">>> nexus-rust-tools available, keeping in package list"
    cp "$PACKAGES_FILE" "$PACKAGES_FILE.unstable"
else
    echo ">>> nexus-rust-tools NOT available, removing from package list"
    grep -v "nexus-rust-tools" "$PACKAGES_FILE" > "$PACKAGES_FILE.unstable"
fi

# Replace the original with unstable version
cp "$PACKAGES_FILE.unstable" "$PACKAGES_FILE"

# Phase 4: Build ISO
echo ""
echo "=== Phase 4: Building ISO ==="
cd "$ROOT"
sudo rm -rf build
echo ">>> Running mkarchiso..."
sudo mkarchiso -v -w build -o out archiso 2>&1 | tee "$ROOT/build-unstable.log"

# Check result
ISO_PATH=$(find "$ROOT/out" -name "*.iso" -print -quit 2>/dev/null)
if [ -n "$ISO_PATH" ]; then
    mkdir -p "$ROOT/out/desktop"
    NEW_ISO="$ROOT/out/desktop/$ISO_NAME"
    mv "$ISO_PATH" "$NEW_ISO"
    
    # Generate checksums
    cd "$(dirname "$NEW_ISO")"
    sha256sum "$(basename "$NEW_ISO")" > SHA256SUMS
    
    # Create .img copy
    cp "$NEW_ISO" "${NEW_ISO%.iso}.img"
    
    # Package list
    cp "$PACKAGES_FILE.unstable" "$ROOT/out/desktop/pkgs-unstable.txt"
    
    echo ""
    echo "=========================================="
    echo "✓ UNSTABLE ISO BUILT SUCCESSFULLY!"
    echo "=========================================="
    echo "ISO:     $NEW_ISO"
    echo "SHA256:  $ROOT/out/desktop/SHA256SUMS"
    echo "IMG:     ${NEW_ISO%.iso}.img"
    echo "PKGS:    $ROOT/out/desktop/pkgs-unstable.txt"
    echo ""
    echo "Note: nexus-rust-tools $( [ $RUST_OK -eq 1 ] && echo "INCLUDED" || echo "EXCLUDED (build failed)" )"
    ls -lh "$NEW_ISO"
else
    echo ""
    echo "=========================================="
    echo "✗ ISO BUILD FAILED"
    echo "=========================================="
    echo "Check $ROOT/build-unstable.log for errors"
    # Restore package file
    cp "$PACKAGES_FILE.bak" "$PACKAGES_FILE" 2>/dev/null || true
    exit 1
fi
# Restore package file
cp "$PACKAGES_FILE.bak" "$PACKAGES_FILE" 2>/dev/null || true
