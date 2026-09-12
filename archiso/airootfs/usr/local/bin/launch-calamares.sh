#!/usr/bin/env bash
set -euo pipefail
# Launches the Calamares installer on the live desktop. Online-only install
# flow: pacstrap-based, uses the online settings_online.conf which
# ships the bootloader and desktop choosers plus the netinstall module.
# Requires a network during install and a published [nexus] repo (GitHub
# Releases). Installed into the ISO as an autostart entry so Calamares opens
# directly instead of a welcome/hello app.
# X-KDE-autostart-phase=1 ensures Plasma starts Calamares after the shell is ready.
# A small delay avoids race where kwin/plasmashell not yet ready on Wayland.

main() {
    # Wait for Plasma session to be ready (plasmashell running)
    for i in {1..30}; do
        if pgrep -x plasmashell >/dev/null 2>&1; then
            break
        fi
        sleep 1
    done
    # Additional small delay for Wayland compositor
    sleep 2
    # Launch online installer; if no network, fallback to offline is handled inside calamares-online.sh?
    # Keep exec so autostart tracks the process.
    exec /usr/local/bin/calamares-online.sh "$@"
}

main "$@"
