#!/bin/bash
# init-easyrsa.sh — initialize offline CA

set -e

EASYRSA_DIR=~/vpn-ca/easy-rsa

# Clone if missing
if [ ! -d "$EASYRSA_DIR" ]; then
  git clone https://github.com/OpenVPN/easy-rsa.git "$EASYRSA_DIR"
fi

cd "$EASYRSA_DIR/easyrsa3"
cp vars.example vars

# Init PKI
chmod +x ./easyrsa
./easyrsa init-pki

echo "PKI initialized. Next: ./easyrsa build-ca"

./easyrsa build-ca

./easyrsa gen-req server nopass
./easyrsa sign-req server server

