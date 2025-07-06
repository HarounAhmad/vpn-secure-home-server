#!/bin/bash
# revoke-cert.sh — revoke client cert and regenerate CRL

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <client-name>"
  exit 1
fi

CLIENT=$1
: "${EASYRSA_DIR:=~/vpn-ca/easy-rsa}"

cd "$EASYRSA_DIR"

./easyrsa revoke "$CLIENT"
./easyrsa gen-crl

echo "Cert for $CLIENT revoked. New crl.pem in pki/."
