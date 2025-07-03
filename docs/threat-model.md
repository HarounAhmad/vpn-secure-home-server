# Threat Model

## 1. Purpose
Document the security assumptions, goals, and limits for this OpenVPN home server architecture.

---

## 2. Assumptions
- The OpenVPN server is hosted on a trusted physical machine in a home network.
- The offline CA machine is secure, air-gapped or never connected to untrusted networks.
- Clients use unique certificates only distributed over secure channels.

---

## 3. Assets to Protect
- Private keys: CA private key, server key, client keys.
- Encrypted VPN traffic.
- Internal services (game servers, admin dashboards, configs).
- LAN resources reachable through VPN.

---

## 4. Threats Covered
 **Port scanning & direct exploits**
- Only OpenVPN port is exposed; everything else is LAN-only.

 **Credential reuse**
- `duplicate-cn` disabled: one connection per cert.
- Static IP mapping + nftables prevents shared cert abuse.

 **Unauthorized access**
- No password logins, certs signed offline only.
- Revocation instantly blocks compromised certs.

 **Traffic sniffing & MITM**
- TLS 1.3 enforced with strong ciphers.
- `tls-crypt` hides handshake metadata.

 **Misconfigured services**
- All containers bind to private interfaces.
- Firewall rules default-deny by design.

---

## 5. Threats Not Covered
 **Physical access to server hardware**
- Disk encryption and physical security are user’s responsibility.

 **Compromised client machine**
- If a device with a cert is infected, attacker can connect until you revoke.

 **Insider LAN threats**
- VPN clients have scoped access but LAN exploits beyond the server’s control are not blocked.

 **Side-channel or quantum crypto attacks**
- Uses best current TLS ciphers but not quantum-resistant.

---

## 6. Residual Risks
- If you do not rotate certs or keys when needed, revoked access can linger.
- If the offline CA is lost or compromised, you must rebuild trust.

---

## 7. Mitigations
- Use CRLs and test revocation regularly.
- Keep the CA truly offline; never copy `ca.key` to the server.
- Use monitoring (Grafana, Prometheus) to track VPN connections.
- Rotate keys and review firewall logs periodically.

---

## References
- [OpenVPN Security](https://openvpn.net/community-resources/security-overview/)
- [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling)
