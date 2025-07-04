#!/bin/bash


docker build -t vpn-test-server .

docker run --privileged --cgroupns=host \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -d \
  vpn-test-server
