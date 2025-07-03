# Secure OpenVPN Home Server Architecture

## Purpose
A hardened, reproducible home server design that uses OpenVPN as the single secure entry point:
- Certificate-based client authentication only (no passwords)
- Offline Certificate Authority (CA) for signing and revocation
- Per-client static IP mapping using `client-config-dir`
- nftables firewall with default-deny policy and per-client allowlists
- Containerized services (Minecraft server, VSCode server, Grafana) accessible only over VPN

## Key Security Features
- TLS 1.3 enforced
- AES-256-GCM encryption, SHA512 auth
- `tls-crypt` hides handshake traffic, blocks port scans
- One active connection per cert (`duplicate-cn` off)
- CRL-based revocation managed by offline CA
- Static VPN IPs + nftables rules restrict each client's access scope

## Repo Structure
```
/
├── docs/         # Architecture overview, threat model, offline CA workflow, firewall design
├── openvpn/      # Example server.conf, CCD static IP mappings
├── nftables/     # Base ruleset and per-client IP allowlists
├── scripts/      # Offline CA scripts: init, sign, revoke, deploy CRL
├── k8s/          # Example Kubernetes manifests: Minecraft, Grafana, VSCode server
```

## Who This Is For
- Anyone building a low-attack-surface home server
- Wants all access gated by cert-auth VPN only
- Needs strict offline cert generation and revocation

## Out of Scope
- Hardware tokens (YubiKeys, smartcards)
- Hosted or online CAs
- Directly exposed SSH or web services

## Quickstart
1. Read [docs/architecture.md](docs/architecture.md) and [docs/threat-model.md](docs/threat-model.md).
2. Run `scripts/init-easyrsa.sh` to initialize the offline CA.
3. Sign new client certs with `sign-client-cert.sh` and assign static IPs via CCD.
4. Apply `nftables/` base + per-client rules for strict access.
5. Deploy your containerized services behind the VPN with the `k8s/` manifests.
6. Revoke and redeploy `crl.pem` using `revoke-cert.sh` and `deploy-crl.sh` as needed.

## Disclaimer
This is a reference blueprint for educational use only. Always audit configs, rotate keys, and adapt to your actual threat model.

## Docs
- [Architecture](docs/architecture.md)
- [Offline CA](docs/offline-ca.md)
- [Firewall](docs/firewall.md)


### Test Run

## Zero Failure Dev Quickstart

# Build your offline CA locally:
./scripts/init-easyrsa.sh

# Verify certs/keys exist:
tree ~/vpn-test

# Start VPN server in container:
docker run --name vpn-server \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -p 1194:1194/udp \
  -v ~/vpn-test:/etc/openvpn \
  my-openvpn-image

# Or for dev:
docker run -it ubuntu bash
# inside: apt install openvpn && openvpn --config /etc/openvpn/server.conf

# On host, run:
sudo openvpn --config client.ovpn
# Look for: Initialization Sequence Completed