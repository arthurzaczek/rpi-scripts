#!/bin/bash

# https://www.raspberryconnect.com/projects/65-raspberrypi-hotspot-accesspoints/158-raspberry-pi-auto-wifi-hotspot-switch-direct-connection

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit
fi

# Step 1
apt-get update
apt-get upgrade

apt-get install -y hostapd dnsmasq

systemctl unmask hostapd
systemctl disable hostapd
systemctl disable dnsmasq

cat > /etc/hostapd/hostapd.conf <<EOF
#2.4GHz setup wifi 80211 b,g,n
interface=wlan0
driver=nl80211

# --------------- CHANGE ME
ssid=RPiHotspot
wpa_passphrase=1234567890
# --------------- CHANGE ME

hw_mode=g
channel=8
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP TKIP
rsn_pairwise=CCMP

#80211n - Change GB to your WiFi country code
country_code=GB
ieee80211n=1
ieee80211d=1
EOF

vim etc/hostapd/hostapd.conf
sed /etc/default/hostapd -i -e "s|^#DAEMON_CONF=.*|DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"|"
sed /etc/default/hostapd -i -e "s|^DAEMON_OPTS=.*|#DAEMON_OPTS=\"\"|"


