#!/usr/bin/env bash
set -euo pipefail

# Ensure we are running as root (re-exec via sudo if needed)
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  exec sudo -E bash "$0" "$@"
fi

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FOLDER="$SCRIPT_DIR"

NMC_FILE="$FOLDER/etc/NetworkManager/system-connections/diyanet-vpn.nmconnection"
TARGET_NMC="/etc/NetworkManager/system-connections/diyanet-vpn.nmconnection"
POLKIT_DIR="/etc/polkit-1/localauthority/50-local.d"
POLKIT_FILE="$POLKIT_DIR/10-network-manager-vpn.pkla"

command -v apt-get >/dev/null 2>&1 || { echo "apt-get not found"; exit 1; }
command -v install >/dev/null 2>&1 || { echo "install tool not found"; exit 1; }
command -v systemctl >/dev/null 2>&1 || { echo "systemctl not found"; exit 1; }

[ -f "$NMC_FILE" ] || { echo "Missing file: $NMC_FILE"; exit 1; }

# Install dependencies
apt-get update
apt-get install -y network-manager-openconnect-gnome network-manager-openconnect openconnect

# Install the NetworkManager connection with secure permissions
install -Dm600 "$NMC_FILE" "$TARGET_NMC"

# Install polkit file to allow system-wide NM settings
mkdir -p "$POLKIT_DIR"
cat > "$POLKIT_FILE" <<'EOF'
[Enable NetworkManager Settings for All Users]
Identity=unix-user:*
Action=org.freedesktop.NetworkManager.settings.modify.system
ResultAny=yes
ResultInactive=yes
ResultActive=yes
EOF

# Ensure strict permissions
chown root:root "$TARGET_NMC" || true
chmod 600 "$TARGET_NMC" || true

# Restart services to apply changes
systemctl restart NetworkManager || true

if command -v nmcli >/dev/null 2>&1; then
  nmcli connection reload || true
fi

echo "diyanet-vpn installation complete." 