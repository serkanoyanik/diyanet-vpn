# diyanet-vpn

Debian packaging for a NetworkManager OpenConnect VPN profile and polkit rules.

## Install directly (root)
```bash
sudo bash ./install.sh
```

## Build .deb package
Requires debhelper (>=13):
```bash
sudo apt-get update && sudo apt-get install -y debhelper
cd "$(dirname "$0")"
dpkg-buildpackage -us -uc -b
```
The resulting .deb will be in the parent directory.

## What it does
- Installs `etc/NetworkManager/system-connections/diyanet-vpn.nmconnection` to `/etc/NetworkManager/system-connections/` with 600 perms
- Installs a polkit file to allow system-wide NetworkManager modifications
- Restarts NetworkManager and reloads connections 