#!/bin/bash
# sign-client-cert.sh — generate and sign client cert

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <client-name>"
  exit 1
fi

CLIENT=$1
EASYRSA_DIR=~/vpn-ca/easy-rsa/easyrsa3

cd "$EASYRSA_DIR"

./easyrsa gen-req "$CLIENT" nopass
./easyrsa sign-req client "$CLIENT"

echo "Client cert signed for $CLIENT"
echo "Copy: pki/issued/$CLIENT.crt and pki/private/$CLIENT.key"
echo "don't forget to make a client ccd for the certificate you created"
echo " echo "ifconfig-push 10.8.0.20 255.255.255.0" > /etc/openvpn/ccd/test-client "
echo " or create the file manually using a text editor and put it in the files you copy to the server"