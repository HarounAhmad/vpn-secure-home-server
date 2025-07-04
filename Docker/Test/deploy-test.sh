#!/bin/bash


docker build -t vpn-test-server .

docker run \
  --privileged --cgroupns=host \
  --name vpn-server-debug \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -p 1194:1194/udp \
  -p 6443:6443/tcp \
  -v ~/vpn-test:/etc/openvpn \
  -v ~/k3s-data:/var/lib/rancher/k3s \
  vpn-test-server