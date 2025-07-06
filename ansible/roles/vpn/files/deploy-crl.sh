#!/bin/bash
# deploy-crl.sh — sync CRL to OpenVPN server

set -e

: "${VPN_SERVER:=root@your.vpn.server}"
: "${REMOTE_PATH:=/etc/openvpn/}"
: "${EASYRSA_DIR:=~/vpn-ca/easy-rsa/easyrsa3}"


cd $EASYRSA_DIR

./easyrsa gen-crl


#scp "$EASYRSA_DIR/pki/crl.pem" "$VPN_SERVER":"$REMOTE_PATH"
#scp -r ~/vpn-test/* root@vpn.server:/etc/openvpn/

echo "CRL created, move it to the server. Restart OpenVPN or send HUP."
