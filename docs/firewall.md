# nftables Firewall Design

## Purpose
Enforce strict, per-client access to internal services using static VPN IPs.  
Default deny: only explicitly allowed traffic passes.

---

## 1️  High-Level Flow
[Client cert] → [VPN assigns static IP] → [nftables matches IP rules] → [Allowed services]

Example:
- `admin` cert → `10.8.0.10` → access to LAN, SSH, Grafana, VSCode.
- `guest` cert → `10.8.0.20` → access only to game server port.

---

## 2️ Static IP Mapping
Use `client-config-dir` in OpenVPN:

client-config-dir /etc/openvpn/ccd

Example `/etc/openvpn/ccd/admin.conf`:

ifconfig-push 10.8.0.10 255.255.255.0

---

## 3️ nftables Base Policy

Sample `nftables/base.nft`:
```nft
table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    # Allow loopback
    iif lo accept

    # Allow OpenVPN port
    tcp dport 443 accept
    udp dport 1194 accept

    # Allow established
    ct state established,related accept

    # Log and drop everything else
    counter log prefix "Dropped Input: " drop
  }

  chain forward {
    type filter hook forward priority 0;
    policy drop;

    # Allow VPN clients by static IP (imported below)
    include "/etc/nftables/per-client-rules.nft"

    ct state established,related accept

    counter log prefix "Dropped Forward: " drop
  }
}
```

## 4 Per-Client Rules
```nft
Example nftables/per-client-rules.nft:

# Admin: full LAN
ip saddr 10.8.0.10 oif eth0 accept

# Guest: Plex server only
ip saddr 10.8.0.20 oif eth0 ip daddr 192.168.0.46 tcp dport 25565 accept
```


## 5 Usage

1: Load base rules:
``` nft -f base.nft ```

2: Maintain per-client includes:

    * Add new client IP mappings.

    * Use explicit ip saddr rules.

3: Block everything else by default.

## 6 Tips
 Test rules with nft list ruleset.
 Log all dropped packets for audit.
 Use nft monitor trace for debugging.
 Reload rules atomically to avoid lockouts.

## 7 Future Enhancements
* MAC address binding (optional, less reliable with VPN).

* Rate limiting suspicious IPs.

* Monitor traffic with Prometheus node exporter.

## References
[nftables Wiki](https://wiki.nftables.org)
[OpenVPN static IP HowTo](https://community.openvpn.net/openvpn/wiki/Concepts-CCD)
