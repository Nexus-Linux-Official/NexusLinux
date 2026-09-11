# Maintainer: Nexus Linux <nexus@nexuslinux.org>
pkgname=nexus-keyring
pkgver=1.0
pkgrel=2
pkgdesc="Nexus Linux package signing keys"
arch=(any)
url="https://github.com/nexuslinux-os/NexusLinux"
license=(GPL-3.0-or-later)
install=nexus-keyring.install

# The keyring files (nexus.gpg / nexus-trusted / nexus-revoked) are produced
# by gen-nexus-keyring.sh, which keeps a persistent signing key under ./gnupg/
# so the fingerprint stays stable across rebuilds. They are intentionally
# not tracked in git (the private key must never be committed).
#
# If the files are missing (fresh clone), prepare() generates a real key
# automatically, so the package can NEVER again ship the invalid placeholder
# armor block that made `pacman-key --populate` fail with:
#   gpg: import from '.../nexus.gpg' failed: Invalid keyring
#   ==> ERROR: A specified keyfile could not be added to the keyring.

prepare() {
    if [[ ! -s "$startdir/nexus.gpg" ]]; then
        echo "nexus-keyring: no keyring found; generating a persistent Nexus master key..."
        bash "$startdir/gen-nexus-keyring.sh"
    fi
}

package() {
    install -dm755 "$pkgdir/usr/share/pacman/keyrings"

    install -Dm644 "$startdir/nexus.gpg" \
        "$pkgdir/usr/share/pacman/keyrings/nexus.gpg"
    install -Dm644 "$startdir/nexus-trusted" \
        "$pkgdir/usr/share/pacman/keyrings/nexus-trusted"
    install -Dm644 "$startdir/nexus-revoked" \
        "$pkgdir/usr/share/pacman/keyrings/nexus-revoked"
}
