#!/bin/bash
# sign-client-cert.sh — generate and sign client cert

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <client-name>"
  exit 1
fi

CLIENT=$1
EASYRSA_DIR=~/vpn-ca/easy-rsa

cd "$EASYRSA_DIR"

./easyrsa gen-req "$CLIENT" nopass
./easyrsa sign-req client "$CLIENT"

echo "Client cert signed for $CLIENT"
echo "Copy: pki/issued/$CLIENT.crt and pki/private/$CLIENT.key"
