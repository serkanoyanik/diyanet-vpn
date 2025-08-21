# diyanet-vpn

Debian sistemler için NetworkManager OpenConnect VPN profili ve polkit kuralları paketi.

## Kurulum

### Doğrudan kurulum (root yetkisi gerekli)
```bash
sudo bash ./install.sh
```

## Neler yapar

- `etc/NetworkManager/system-connections/diyanet-vpn.nmconnection` dosyasını `/etc/NetworkManager/system-connections/` konumuna 600 izniyle kurar
- Sistem geneli NetworkManager değişikliklerine izin veren polkit dosyası ekler
- NetworkManager'ı yeniden başlatır ve bağlantıları yeniden yükler

## Paket bağımlılıkları

- network-manager-openconnect-gnome
- network-manager-openconnect  
- openconnect

## Lisans

Bu proje açık kaynaklıdır. 