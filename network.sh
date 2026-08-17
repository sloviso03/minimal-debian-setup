#!/usr/bin/env bash

set -e

echo "Migrating network configuration to NetworkManager..."

if ! command -v nmcli >/dev/null 2>&1; then
    echo "ERROR: NetworkManager is not installed."
    exit 1
fi

WIFI_IFACE=""

for iface in /sys/class/net/*; do
    iface=$(basename "$iface")

    if [ "$iface" = "lo" ]; then
        continue
    fi

    if [ -d "/sys/class/net/$iface/wireless" ]; then
        WIFI_IFACE="$iface"
        break
    fi
done

echo "Wi-Fi interface: ${WIFI_IFACE:-not detected}"

SSID=""
PSK=""

if [ -f /etc/network/interfaces ]; then
    SSID=$(sudo awk '
        /wpa-ssid/ {
            gsub(/"/, "", $2)
            print $2
            exit
        }
    ' /etc/network/interfaces)

    PSK=$(sudo awk '
        /wpa-psk/ {
            gsub(/"/, "", $2)
            print $2
            exit
        }
    ' /etc/network/interfaces)
fi

if [ -z "$SSID" ] && [ -f /etc/wpa_supplicant/wpa_supplicant.conf ]; then
    SSID=$(sudo awk -F= '
        /^[[:space:]]*ssid=/ {
            gsub(/"/, "", $2)
            print $2
            exit
        }
    ' /etc/wpa_supplicant/wpa_supplicant.conf)

    PSK=$(sudo awk -F= '
        /^[[:space:]]*psk=/ {
            gsub(/"/, "", $2)
            print $2
            exit
        }
    ' /etc/wpa_supplicant/wpa_supplicant.conf)
fi

echo "Detected SSID: ${SSID:-none}"

sudo mkdir -p /etc/NetworkManager/conf.d

sudo tee /etc/NetworkManager/conf.d/10-managed.conf >/dev/null <<'EOF'
[ifupdown]
managed=true
EOF

if [ -n "$WIFI_IFACE" ] && [ -n "$SSID" ] && [ -n "$PSK" ]; then
    echo "Creating NetworkManager profile for: $SSID"

    sudo nmcli connection delete "$SSID" 2>/dev/null || true

    sudo nmcli connection add \
        type wifi \
        ifname "$WIFI_IFACE" \
        con-name "$SSID" \
        ssid "$SSID"

    sudo nmcli connection modify "$SSID" \
        wifi-sec.key-mgmt wpa-psk

    sudo nmcli connection modify "$SSID" \
        wifi-sec.psk "$PSK"
else
    echo "Could not automatically recover the Wi-Fi configuration."
    echo "You can configure it manually using:"
    echo
    echo "    nmtui"
    echo
fi

sudo cp /etc/network/interfaces \
    /etc/network/interfaces.backup

sudo tee /etc/network/interfaces >/dev/null <<'EOF'
auto lo
iface lo inet loopback
EOF

sudo systemctl disable networking 2>/dev/null || true
sudo systemctl stop networking 2>/dev/null || true

sudo systemctl enable NetworkManager
sudo systemctl restart NetworkManager

sleep 3

sudo nmcli radio wifi on

if [ -n "$SSID" ] && nmcli connection show "$SSID" >/dev/null 2>&1; then
    echo "Connecting to $SSID..."
    sudo nmcli connection up "$SSID" || true
fi

echo

nmcli device status

echo
echo "Connections:"
nmcli connection show

echo
echo "Backup:"
echo "  /etc/network/interfaces.backup"
echo
