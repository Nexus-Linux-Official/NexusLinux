#!/usr/bin/env sh
set -euo pipefail
# borrowed from manjaro livecd

xdg=$(xdg-user-dir DESKTOP)
src='/usr/share/applications'

## We don't need .desktop on desktop,
## actually we should remove .desktop or fix the .desktop as it is running with pkexec,
userid=$(id -u $USER)
if [ ! -d "/.Trash-$userid" ]; then
    sudo mkdir -p /.Trash-$userid/{expunged,files,info}
    sudo chown -R $userid /.Trash-$userid
fi

# mark launchers trusted for XFCE 4.18
for f in $(ls $xdg/*desktop); do
    gio set -t string $f metadata::xfce-exe-checksum "$(sha256sum $f | awk '{print $1}')"
done;
