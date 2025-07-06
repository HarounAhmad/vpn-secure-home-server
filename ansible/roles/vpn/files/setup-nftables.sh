#!/bin/bash
# setup-nftables.sh - deploy nftables firewall with client rules for VPN server

set -e

: "${MAIN_RULES_PATH:=/etc/nftables/main.nft}"
: "${CLIENT_RULES_PATH:=/etc/nftables/per-client-rules.nft}"
: "${NFT_CONF:=/etc/nftables.conf}"

# Write main nftables rules
cp base.nft $MAIN_RULES_PATH

# Write example client rules
cp per-client-rules.nft $CLIENT_RULES_PATH

# Flush current ruleset
sudo nft flush ruleset

# Load main ruleset
sudo nft -f "$MAIN_RULES_PATH"

# Save rules to nftables.conf for persistence
sudo nft list ruleset | sudo tee "$NFT_CONF" > /dev/null

# Enable nftables service if available
if systemctl list-unit-files | grep -q nftables.service; then
  sudo systemctl enable nftables.service
  sudo systemctl restart nftables.service
fi

echo "nftables rules deployed and persisted."
