#!/bin/bash


: "${SRC:=~/vpn}"
: "${DST:=/etc/openvpn}"

PKI="$DST/pki"
ISSUED="$PKI/issued"
PRIVATE="$PKI/private"
CCD="$DST/ccd"



sudo mkdir -p "$ISSUED" "$PRIVATE" "$CCD"

sudo cp "$SRC/server.conf" "$DST/"
sudo cp "$SRC/ca.crt" "$DST/"
sudo cp "$SRC/crl.pem" "$DST/"
sudo cp "$SRC/ta.key" "$DST/"

sudo cp "$SRC/pki/issued/server.crt" "$ISSUED/"
sudo cp "$SRC/pki/private/server.key" "$PRIVATE/"
sudo cp "$SRC/ccd/"* "$CCD/"

sudo chmod 600 "$DST/"*.key "$PRIVATE/"*
sudo chown root:root "$DST/"*.key "$PRIVATE/"*

ls -l "$DST/"
ls -l "$ISSUED/"
ls -l "$PRIVATE/"
ls -l "$CCD/"

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i 's/^#*net.ipv4.ip_forward=.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p

sudo openvpn --config "$DST/server.conf"
