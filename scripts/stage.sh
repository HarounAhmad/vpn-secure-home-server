#!/bin/bash

mkdir -p ~/vpn-test/pki/issued ~/vpn-test/pki/private ~/vpn-test/ccd

cp ~/vpn-ca/easy-rsa/easyrsa3/pki/ca.crt ~/vpn-test/
cp ~/vpn-ca/easy-rsa/easyrsa3/pki/issued/server.crt ~/vpn-test/pki/issued/
cp ~/vpn-ca/easy-rsa/easyrsa3/pki/private/server.key ~/vpn-test/pki/private/
cp ~/vpn-ca/easy-rsa/easyrsa3/pki/issued/test-client.crt ~/vpn-test/pki/issued/
cp ~/vpn-ca/easy-rsa/easyrsa3/pki/private/test-client.key ~/vpn-test/pki/private/
cp ~/vpn-ca/easy-rsa/easyrsa3/pki/crl.pem ~/vpn-test/
cp ~/vpn-ca/easy-rsa/easyrsa3/ta.key ~/vpn-test/

# Static IP mapping (per-client)
cp ../openvpn/ccd-example/* -r ~/vpn-test/ccd/

# server conf
cp ../openvpn/server.conf -r ~/vpn-test/

