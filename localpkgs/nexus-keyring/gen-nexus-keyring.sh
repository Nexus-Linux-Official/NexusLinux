#!/usr/bin/env bash
# Generate (or reuse) the Nexus Linux master signing key and derive the
# pacman keyring files consumed by the nexus-keyring package.
#
# Run from localpkgs/nexus-keyring/:
#   ./gen-nexus-keyring.sh
#
# The private key lives ONLY in ./gnupg/ - BACK THAT DIRECTORY UP.
# Rebuild the package after (re)generating:
#   cd localpkgs/nexus-keyring && makepkg -f

set -euo pipefail

startdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export GNUPGHOME="$startdir/gnupg"
KEY_ID="Nexus Linux Packaging <nexus@nexuslinux.org>"

mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Generate the master key once, reuse it forever afterwards.
if ! gpg --batch --list-keys "$KEY_ID" >/dev/null 2>&1; then
    echo ">>> Generating Nexus master signing key (RSA 4096, no expiry)..."
    gpg --batch --gen-key <<'EOF'
%no-protection
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Nexus Linux Packaging
Name-Email: nexus@nexuslinux.org
Expire-Date: 0
%commit
EOF
fi

FPR="$(gpg --batch --with-colons --list-keys "$KEY_ID" | awk -F: '/^fpr:/ {print $10; exit}')"
echo ">>> Nexus master key fingerprint: $FPR"

# Public keyring consumed by `pacman-key --populate nexus`
gpg --batch --yes --output "$startdir/nexus.gpg" --export "$KEY_ID"

# Ownertrust: fully trust our own master key (':4:')
printf '%s:4:\n' "$FPR" > "$startdir/nexus-trusted"
: > "$startdir/nexus-revoked"

echo ">>> Wrote nexus.gpg, nexus-trusted, nexus-revoked in $startdir"
echo ">>> BACK UP '$GNUPGHOME' - losing it loses the signing key."
