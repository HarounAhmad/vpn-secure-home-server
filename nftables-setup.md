# nftables Quickstart Guide

## Overview

This guide explains how to deploy nftables firewall rules for your VPN server, controlling input and forwarding traffic with client-specific permissions.

Note:
There is a script which does this however it is a good idea to read through this document in order to understand what the script is doing (nftables/setup-nftables.sh)
---

## Firewall Rules Example

```nft
table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    # Allow loopback interface
    iif lo accept

    # Allow OpenVPN UDP port
    udp dport 1194 accept

    # Allow established and related connections
    ct state established,related accept

    # Log and drop everything else
    counter log prefix "Dropped Input: " drop
  }

  chain forward {
    type filter hook forward priority 0;
    policy drop;

    # Include per-client VPN allow rules
    include "/etc/nftables/per-client-rules.nft"

    # Allow established and related traffic
    ct state established,related accept

    # Log and drop everything else
    counter log prefix "Dropped Forward: " drop
  }
}
```

## Per-client rules example (/etc/nftables/per-client-rules.nft)
```nft
# Admin client: full LAN access
ip saddr 10.8.0.10 accept

# Guest client: allow Minecraft server only
ip saddr 10.8.0.20 ip daddr 192.168.0.46 tcp dport 25565 accept
ip saddr 10.8.0.20 ip daddr 192.168.0.46 udp dport 25565 accept
```


## Deployment Steps

1:  Save the main firewall rules to /etc/nftables/main.nft.

2:  Save the client-specific rules to /etc/nftables/per-client-rules.nft.

3:  Test the syntax:

```bash
sudo nft -c -f /etc/nftables/main.nft
sudo nft -c -f /etc/nftables/per-client-rules.nft

```

4: Load rules into nftables

```nft
sudo nft flush ruleset
sudo nft -f /etc/nftables/main.nft
```

5:  Persist rules on reboot:

*   Save current rules
    ```bash
    sudo nft list ruleset > /etc/nftables.conf
    
    ```

*   Enable nftables service to load rules on boot (systemd):
       ```bash
        sudo systemctl enable nftables.service
        sudo systemctl start nftables.service    
        ```


## Notes
* Adujust VPN port `1194` if your server uses a different port.
* Replace IP addresses in per-client rules with your VPN client static IPs.
* Add any additional required ports (e.g., HTTPS `443`) in the input `chain` as needed.
* Logs will appear in your system log with prefixes `Dropped Input: ` and `Dropped Forward: `.

 
