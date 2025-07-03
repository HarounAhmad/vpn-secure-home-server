#!/bin/bash
# deploy-crl.sh — sync CRL to OpenVPN server

set -e

VPN_SERVER=root@your.vpn.server
REMOTE_PATH=/etc/openvpn/

EASYRSA_DIR=~/vpn-ca/easy-rsa

scp "$EASYRSA_DIR/pki/crl.pem" "$VPN_SERVER":"$REMOTE_PATH"

echo "CRL deployed to VPN server. Restart OpenVPN or send HUP."
