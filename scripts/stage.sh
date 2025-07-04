#!/bin/bash

SRC_CA=~/vpn-ca/easy-rsa/easyrsa3/pki
SRC_TA=~/vpn-ca/easy-rsa/easyrsa3/ta.key
SRC_CCD=../openvpn/ccd-example
SRC_CONF=../openvpn/server.conf

DST=~/vpn-test
PKI_ISSUED=$DST/pki/issued
PKI_PRIVATE=$DST/pki/private
CCD=$DST/ccd

mkdir -p "$PKI_ISSUED" "$PKI_PRIVATE" "$CCD"

cp "$SRC_CA/ca.crt" "$DST/"
cp "$SRC_CA/issued/server.crt" "$PKI_ISSUED/"
cp "$SRC_CA/private/server.key" "$PKI_PRIVATE/"
cp "$SRC_CA/issued/test-client.crt" "$PKI_ISSUED/"
cp "$SRC_CA/private/test-client.key" "$PKI_PRIVATE/"
cp "$SRC_CA/crl.pem" "$DST/"
cp "$SRC_TA" "$DST/"

cp -r "$SRC_CCD/"* "$CCD/"
cp "$SRC_CONF" "$DST/"
