# Architecture Overview

## 1. High-Level Concept
All public access tunnels through OpenVPN.
- No SSH, HTTP, or other services exposed directly.
- VPN enforces certificate-based auth only.
- Firewall (`nftables`) maps per-client VPN IPs to specific LAN/service ports.
- All services run in containers or Kubernetes, binding only to private LAN.

---

## 2. Components

###  Offline Certificate Authority (CA)
- Located on your personal PC (air-gapped or non-networked).
- Uses `easy-rsa` or OpenSSL.
- Generates:
  - Server cert & key
  - Client certs & keys
  - `crl.pem` for revocation
- Only signed certs can connect.

###  OpenVPN Server
- Runs on the home server.
- Exposes only UDP port 1194 (or TCP 443 if needed).
- `duplicate-cn` off: one active connection per cert.
- Uses `client-config-dir` to map cert CN → static VPN IP.
- Uses `tls-crypt` to hide handshake.

###  nftables Firewall
- Default deny on all input/forward.
- Allows only VPN port and VPN tunnel IP ranges.
- Per-client IP rules:
  - Admin IP: full LAN access.
  - Guest IP: only game server ports.
- Enforced with separate `base.nft` and `per-client-rules.nft`.

###  Containerized Services (Kubernetes)
- Services run behind VPN:
  - Minecraft server
  - VSCode server for config editing
  - Grafana/Prometheus for monitoring
- Bind only to LAN IPs.

---

## 3. Traffic Flow

[Client Machine]
|
[VPN Tunnel (cert auth, TLS 1.3)]
|
[OpenVPN Server]
|
[nftables Firewall (per-client IP rules)]
|
[Internal LAN + Containers]


- Clients get static VPN IP.
- Firewall enforces what each IP can talk to.
- Revoked certs immediately blocked via CRL.

---

## 4. Revocation Workflow

- Any cert can be revoked using the offline CA:
./scripts/revoke-cert.sh
./scripts/deploy-crl.sh

- Updated `crl.pem` blocks the cert server-side.

---

## 5. Key Security Controls

 TLS 1.3 + modern ciphers (AES-256-GCM, SHA512)  
 `tls-crypt` to hide handshake  
 Offline CA: no private key on server  
 `duplicate-cn` off: one active session per cert  
 nftables default deny + static IP maps  
 Separate admin/guest certs with different rules  
 All services require VPN tunnel — zero public exposure

---

## 6. Next Steps

- See `docs/offline-ca.md` for CA setup.
- See `docs/firewall.md` for applying nftables.
- Use `scripts/` for managing certs and revocation.
- Deploy game servers using examples in `k8s/`.
