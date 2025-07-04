#!/bin/bash
set -e

echo "Starting k3s server in foreground..."
exec /usr/local/bin/k3s server --tls-san 127.0.0.1