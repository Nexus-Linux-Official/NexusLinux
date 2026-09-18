#!/usr/bin/env bash
set -e

# Nexus branding and theme setup (no Calamares dependency)

# Apply the Nexus Look-and-Feel global theme BEFORE skeleton copy.
# We now ship a complete "Nexus" look-and-feel theme
if command -v lookandfeeltool &>/dev/null; then
    QT_QPA_PLATFORM=offscreen lookandfeeltool -a Nexus || echo "WARNING: lookandfeeltool -a Nexus failed"
fi

# Calamares installation and configuration
if command -v pacman &>/dev/null && pacman -Qs calamares &>/dev/null; then
    # Copy Calamares Nexus branding
    if [ -d /usr/share/nexus-calamares ]; then
        cp -r /usr/share/nexus-calibranding/nexus /usr/share/calamares/branding/nexus 2>/dev/null || true
        # Copy Calamares modules
        cp -r /usr/share/nexus-calamares/modules/ /etc/calamares/modules/ 2>/dev/null || true
        # Apply branding replacements
        sed -i 's|branding: cachyos|branding: nexus|' /etc/calamares/settings.conf 2>/dev/null || true
        sed -i 's|CachyOS|Nexus Linux|' /etc/calamares/modules/welcome.conf 2>/dev/null || true
    fi
fi

# Now overwrite skeleton files with the canonical Nexus configs (wallpaper,
# panel layout, cursor/icon/theme) so they take precedence over anything
# the KDE settings wrote.
NEXUS_SKEL=/usr/share/nexus-skel/.config
for conf in kdeglobals kwinrc plasmarc plasma-org.kde.plasma.desktop-appletsrc; do
    if [ -f "$NEXUS_SKEL/$conf" ]; then
        install -Dm644 "$NEXUS_SKEL/$conf" "/etc/skel/.config/$conf"
        if [ -d /home/liveuser ]; then
            install -Dm644 "$NEXUS_SKEL/$conf" "/home/liveuser/.config/$conf"
        fi
    fi
done

# Disable KDE Plasma splash screen (ksplash). After plymouth exits, KDE would
# normally show its own Breeze splash animation before the desktop appears.
# We only want the plymouth Nexus splash; disable ksplash via plasmarc.
for _skel in /etc/skel /home/liveuser; do
    [ -d "$_skel" ] || continue
    cat >> "$_skel/.config/plasmarc" <<'PLASMA'

[KSplash]
Theme=none
PLASMA
done

# Drop KDE settings leftovers from both the installed-system
# skeleton and the live user's home, preserving our Nexus theme configs.
for _skel in /etc/skel /home/liveuser; do
    [ -d "$_skel" ] || continue
    rm -rf "$_skel/.config/kdedefaults"
    rm -f "$_skel/.config/plasmashellrc"
    rm -f "$_skel/.config/Trolltech.conf"
    rm -rf "$_skel/.config/gtk-3.0"
    rm -rf "$_skel/.config/gtk-4.0"
    rm -rf "$_skel/.config/xsettingsd"
    rm -f "$_skel/.config/dconf/user"
done

# The branding os-release hook writes a generic name into /etc/os-release during
# pacstrap. Overwrite it so the live session identifies as Nexus Linux. Preserve the
# IMAGE_ID/IMAGE_VERSION lines appended by mkarchiso.
_IMAGE_ID="$(sed -n 's/^IMAGE_ID=//p' /etc/os-release)"
_IMAGE_VERSION="$(sed -n 's/^IMAGE_VERSION=//p' /etc/os-release)"
cat > /etc/os-release <<EOF
NAME="Nexus Linux"
PRETTY_NAME="Nexus Linux"
ID=nexus
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
IMAGE_ID=${_IMAGE_ID}
IMAGE_VERSION=${_IMAGE_VERSION}
EOF

# Nexus-branded lsb-release for the live session.
cat > /etc/lsb-release <<EOF
LSB_VERSION=1.4
DISTRIB_ID=Nexus
DISTRIB_RELEASE=rolling
DISTRIB_DESCRIPTION="Nexus Linux"
EOF

# Add the plymouth hook to /etc/mkinitcpio.conf so installed systems (whose
# initramfs is generated from this file by Calamares) boot into the Nexus
# splash as well. The live ISO boot uses the mkinitcpio.conf.d/archiso.conf
# drop-in, which already contains the plymouth hook.
if [ -f /etc/mkinitcpio.conf ]; then
    sed -i 's/^HOOKS=(base /HOOKS=(base plymouth /' /etc/mkinitcpio.conf
fi

# Ensure the installed GRUB passes 'splash' (and quiet) so plymouth shows.
if [ -f /etc/default/grub ]; then
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash"/' /etc/default/grub
fi

# Rebuild all initramfs images now that the Nexus plymouth theme and
# /etc/plymouth/plymouthd.conf are in place. The initramfs generated during
# pacstrap was built before the profile airootfs was copied over, so it would
# otherwise not contain the plymouth hook/theme.
if [ -x /usr/bin/mkinitcpio ]; then
    mkinitcpio -P || echo "WARNING: mkinitcpio -P failed; plymouth may not be in the initramfs"
fi

# Ensure the installed GRUB passes 'splash' (and quiet) so plymouth shows.
if [ -f /etc/default/grub ]; then
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash"/' /etc/default/grub
fi

# Rebuild all initramfs images now that the Nexus plymouth theme and
# /etc/plymouth/plymouthd.conf are in place. The initramfs generated during
# pacstrap was built before the profile airootfs was copied over, so it would
# otherwise not contain the plymouth hook/theme.
if [ -x /usr/bin/mkinitcpio ]; then
    mkinitcpio -P || echo "WARNING: mkinitcpio -P failed; plymouth may not be in the initramfs"
fi

# Ensure the installed GRUB passes 'splash' (and quiet) so plymouth shows.
if [ -f /etc/default/grub ]; then
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash"/' /etc/default/grub
fi

# Rebuild all initramfs images now that the Nexus plymouth theme and
# /etc/plymouth/plymouthd.conf are in place. The initramfs generated during
# pacstrap was built before the profile airootfs was copied over, so it would
# otherwise not contain the plymouth hook/theme.
if [ -x /usr/bin/mkinitcpio ]; then
    mkinitcpio -P || echo "WARNING: mkinitcpio -P failed; plymouth may not be in the initramfs"
fi