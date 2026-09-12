#!/usr/bin/env bash
set -e

# Nexus calamares modules are copied after pacstrap
NEXUS_CALAMARES=/usr/share/nexus-calamares/modules
for conf in netinstall.yaml packagechooser_desktop.conf shellprocess.conf; do
    if [ -f "$NEXUS_CALAMARES/$conf" ]; then
        install -Dm644 "$NEXUS_CALAMARES/$conf" "/etc/calamares/modules/$conf"
    fi
done

# Bake Nexus branding into Calamares at build time
if [ -d /usr/share/nexus-calamares/look-and-feel/nexus ]; then
    cp -r /usr/share/nexus-calamares/look-and-feel/nexus /usr/share/calamares/branding/nexus
fi
if [ -f /usr/share/calamares/settings_online.conf ]; then
    install -Dm644 /usr/share/calamares/settings_online.conf /etc/calamares/settings.conf
fi

# welcome.conf / shellprocess-before.conf / users.conf are NOT part of the
# nexus-calamares override package - Calamares ships its own defaults for
# these under /usr/share/calamares/modules/. Calamares treats
# /etc/calamares/modules/ as an override layer: if a file isn't there, the
# /usr/share default is used untouched (and sed-ing a nonexistent /etc file
# fails the whole build). So before sed'ing, make sure an editable copy
# exists in /etc first, copying the shipped default if needed.
CALAMARES_DEFAULTS=/usr/share/calamares/modules
CALAMARES_ETC=/etc/calamares/modules
mkdir -p "$CALAMARES_ETC"
for conf in welcome.conf shellprocess-before.conf users.conf; do
    if [ ! -f "$CALAMARES_ETC/$conf" ] && [ -f "$CALAMARES_DEFAULTS/$conf" ]; then
        install -Dm644 "$CALAMARES_DEFAULTS/$conf" "$CALAMARES_ETC/$conf"
    fi
done

# Only sed files that actually exist (some modules don't ship default configs)
[ -f /etc/calamares/modules/welcome.conf ] && sed -i 's/CachyOS/Nexus Linux/g' /etc/calamares/modules/welcome.conf
[ -f /etc/calamares/modules/shellprocess-before.conf ] && sed -i 's/CachyOS/Nexus Linux/g' /etc/calamares/modules/shellprocess-before.conf
[ -f /etc/calamares/modules/users.conf ] && sed -i 's/cachyos-${cpu}/nexus-${cpu}/' /etc/calamares/modules/users.conf

# Apply the Nexus Look-and-Feel global theme BEFORE skeleton copy.
# We now ship a complete "Nexus" look-and-feel theme in the nexus-calamares package.
if command -v lookandfeeltool &>/dev/null; then
    QT_QPA_PLATFORM=offscreen lookandfeeltool -a Nexus || echo "WARNING: lookandfeeltool -a Nexus failed"
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

# Launch the Calamares installer directly on the live desktop instead of a
# welcome app. The launcher always runs the normal (offline) install flow.
# Use both skel and global xdg autostart so KDE Plasma (Wayland/X11) reliably starts it.
mkdir -p /etc/skel/.config/autostart
mkdir -p /etc/xdg/autostart
cat > /etc/skel/.config/autostart/calamares.desktop <<'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=Install Nexus Linux
Name[tr]=Nexus Linux Kur
GenericName=System Installer
Comment=Install Nexus Linux on this computer.
Comment[tr]=Nexus Linux'u bu bilgisayara kur.
Exec=/usr/local/bin/launch-calamares.sh
Icon=calamares
Terminal=false
StartupNotify=true
Categories=System;Qt;
X-GNOME-Autostart-enabled=true
X-KDE-autostart-phase=1
X-KDE-StartupNotify=false
Hidden=false
NoDisplay=false
DBusActivatable=false
EOF
# Global autostart ensures it runs even if skel copy is missed (Plasma reads /etc/xdg/autostart)
install -Dm644 /etc/skel/.config/autostart/calamares.desktop /etc/xdg/autostart/calamares.desktop
# Also ensure a copy in /etc/xdg/autostart is marked executable via profiledef
chmod 644 /etc/xdg/autostart/calamares.desktop

# mkarchiso copies /etc/skel into /home/liveuser before this script runs, so
# the autostart dir does not exist there yet. Create it unconditionally,
# otherwise Calamares would never autostart in the live session.
mkdir -p /home/liveuser/.config/autostart
cp /etc/skel/.config/autostart/calamares.desktop /home/liveuser/.config/autostart/calamares.desktop
chown liveuser:liveuser /home/liveuser/.config/autostart/calamares.desktop 2>/dev/null || true

# Ensure Calamares also appears in the application menu: the calamares package ships
# /usr/share/applications/calamares.desktop with TryExec=calamares. If the binary is
# not yet in PATH at menu-cache build time it may be hidden – ensure it is visible
# by removing NoDisplay/Hidden and updating desktop database.
if [ -f /usr/share/applications/calamares.desktop ]; then
    sed -i 's/^NoDisplay=.*/NoDisplay=false/' /usr/share/applications/calamares.desktop 2>/dev/null || true
    sed -i 's/^Hidden=.*/Hidden=false/' /usr/share/applications/calamares.desktop 2>/dev/null || true
    # Ensure the Nexus branded name appears in menu as well
    if ! grep -q "Name=Install Nexus" /usr/share/applications/calamares.desktop; then
        sed -i 's/^Name=.*/Name=Install Nexus Linux/' /usr/share/applications/calamares.desktop 2>/dev/null || true
    fi
fi
# Update desktop database so KDE finds the new .desktop files
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database /usr/share/applications 2>/dev/null || true
    update-desktop-database /etc/xdg/autostart 2>/dev/null || true
fi

# Compile the Nexus dconf database so GTK-based desktop environments
# (GNOME, Cinnamon, MATE) pick up the Nexus wallpaper as their default.
if [ -x /usr/bin/dconf ]; then
    dconf update || echo "WARNING: dconf update failed; GTK DE wallpaper defaults may not apply"
fi

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