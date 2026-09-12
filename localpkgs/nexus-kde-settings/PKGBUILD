# Maintainer: Nexus Linux <nexus@nexuslinux.org>
pkgname=nexus-kde-settings
pkgver=1.0
pkgrel=1
pkgdesc="Default KDE Plasma settings for Nexus Linux"
arch=(any)
url="https://github.com/nexuslinux-os/NexusLinux"
license=(GPL-3.0-or-later)
depends=(nexus-wallpapers plasma-workspace)
install=nexus-kde-settings.install
source=(
    kdeglobals
    kwinrc
    plasmarc
    plasma-org.kde.plasma.desktop-appletsrc
    nexus-kde-settings.install
)
sha256sums=('dfb69ee1d40c409050d1406cc507737f5290e3036f9b0829ed992de05f7e2d46'
           '474d3235453cb5d6d028acb8214943e116e4f19ad52f72a86af5b9b7b774469a'
           '4ee9717c85f4df469d80cfe17f0451eb6e57c375f5b446aa7f79ee3a86dd0dbb'
           'a7d764c2673fad02589caa41581907b1da5c58efc36f648c07b203499712aa7e'
           '9fd89f66bd62f4710bcf8d5feff2973a6131140d3018f7e629432347b66f8a6f')

package() {
    install -dm755 "$pkgdir/usr/share/nexus-kde-settings"
    
    install -m644 kdeglobals "$pkgdir/usr/share/nexus-kde-settings/kdeglobals"
    install -m644 kwinrc "$pkgdir/usr/share/nexus-kde-settings/kwinrc"
    install -m644 plasmarc "$pkgdir/usr/share/nexus-kde-settings/plasmarc"
    install -m644 plasma-org.kde.plasma.desktop-appletsrc "$pkgdir/usr/share/nexus-kde-settings/plasma-org.kde.plasma.desktop-appletsrc"
    
    # Install to nexus-skel for live user
    install -dm755 "$pkgdir/usr/share/nexus-skel/.config"
    install -m644 kdeglobals "$pkgdir/usr/share/nexus-skel/.config/kdeglobals"
    install -m644 kwinrc "$pkgdir/usr/share/nexus-skel/.config/kwinrc"
    install -m644 plasmarc "$pkgdir/usr/share/nexus-skel/.config/plasmarc"
    install -m644 plasma-org.kde.plasma.desktop-appletsrc "$pkgdir/usr/share/nexus-skel/.config/plasma-org.kde.plasma.desktop-appletsrc"
}