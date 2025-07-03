# Secure OpenVPN Home Server Architecture

## Purpose
A hardened, reproducible home server setup using OpenVPN with:
- Certificate-based client authentication only
- Offline Certificate Authority (CA) for signing and revocation
- Per-client static IP mapping with `client-config-dir`
- nftables firewall with strict per-client rules
- Containerized services (Minecraft server, VSCode-server, Grafana)
- VPN as the single entry point; no other ports exposed

## Key Security Features
- TLS 1.3 enforced
- AES-256-GCM encryption, SHA512 auth
- `tls-crypt` to hide handshake traffic and resist port scanning
- One active connection per cert (`duplicate-cn` off)
- CRL-based revocation handled offline
- Admin and guest clients restricted by static IPs and nftables rules

## Repo Structure
/
├── docs/ # Detailed architecture, threat model, offline CA workflow, firewall design
├── openvpn/ # Sample server.conf and example ccd static IP mappings
├── nftables/ # Base firewall rules and per-client rules
├── scripts/ # Scripts for CA initialization, cert signing, revocation, and CRL deployment
├── k8s/ # Example Kubernetes manifests for game servers and admin tools



## Who Should Use This
- Anyone who wants a minimal-attack-surface home server
- Needs strict VPN gating and per-client access control
- Wants a reproducible, offline-signed cert workflow

## What’s Not Included
- Physical hardware tokens (YubiKeys, smartcards)
- Cloud CA or automated cert signing on the server
- Public-facing SSH or web services outside VPN

## How to Start
1. Read `docs/architecture.md` and `docs/threat-model.md` for full overview.
2. Use `scripts/init-easyrsa.sh` to set up your offline CA.
3. Generate client certs with `sign-client-cert.sh` and map static IPs in `openvpn/ccd-example/`.
4. Apply `nftables/` rules to enforce per-client access.
5. Deploy containerized services behind the VPN using the `k8s/` examples.

## Disclaimer
This is a reference architecture for educational purposes. Audit every config, rotate keys properly, and adapt to your real environment.

---

**Links**
- [docs/architecture.md](docs/architecture.md)
- [docs/offline-ca.md](docs/offline-ca.md)
- [docs/firewall.md](docs/firewall.md)
