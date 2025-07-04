#!/bin/bash
set -e

echo "Starting k3s..."
/usr/local/bin/k3s server --tls-san 127.0.0.1 > /var/log/k3s.log 2>&1 &

echo "Starting OpenVPN..."
ls /etc/openvpn/
cd /etc/openvpn/
pwd
openvpn --config /etc/openvpn/server.conf > /var/log/openvpn.log 2>&1 &

echo "Processes running in background. Use logs:"
echo "  tail -f /var/log/k3s.log"
echo "  tail -f /var/log/openvpn.log"

exec tail -F /var/log/k3s.log /var/log/openvpn.log


# Wait for both to exit
wait -n
