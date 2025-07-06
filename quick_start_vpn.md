# VPN Secure Home Server - Quickstart Guide

This guide references the provided Bash scripts for setting up and managing your OpenVPN server with Easy-RSA.

---

## 1. Initialize Easy-RSA CA and Server Certificates

Script: `init-easyrsa.sh`

- Clones Easy-RSA repo if missing.
- Initializes the Public Key Infrastructure (PKI).
- Builds the CA certificate without password.
- Generates and signs the server certificate.

Run this script first to create your CA and server certs.

---

## 2. Generate and Sign Client Certificates

Script: `sign-client-cert.sh`

- Takes one argument: `<client-name>`.
- Generates a client certificate request and signs it using your CA.
- Instructs to create a client-specific CCD file with static IP assignment.

Use this script for each new client connecting to the VPN.

---

## 3. Prepare VPN Server Files for Deployment

Script: `stage.sh`
- Takes one argument `<client-cert-destination>`
- Copies the CA cert, server cert/key, client cert/key, TLS-auth key, CRL, CCD files, and server config into a deployment directory.
- Creates necessary directories (`pki/issued`, `pki/private`, `ccd`).

Run this after generating certificates to prepare files for the VPN server.

---

## 4. Deploy VPN Server Files and Start OpenVPN

Script: `server-file-setup.sh`

- Copies prepared files to `/etc/openvpn` on the server.
- Sets permissions for private keys.
- Enables IP forwarding system-wide.
- Starts OpenVPN using the provided server config.

Run this on your VPN server to finalize setup and start the service.

---

## 5. Revoke Client Certificates

Script: `revoke-cert.sh`

- Takes one argument: `<client-name>`.
- Revokes the specified client certificate.
- Regenerates the Certificate Revocation List (CRL).

After revocation, update the server with the new CRL.

---

## 6. Deploy Updated CRL to Server

Script: `deploy-crl.sh`

- Generates a new CRL.
- Copies the CRL to the VPN server (adjust `VPN_SERVER` variable).
- Reminds to reload or restart OpenVPN to apply changes.

Use this to propagate client revocations to the VPN server.

---

# Summary

- Use `init-easyrsa.sh` first to create CA and server certs.
- Use `sign-client-cert.sh` for each client.
- Run `stage.sh` to collect files for deployment.
- Deploy with `server-file-setup`.
- Revoke clients using `revoke-cert.sh`.
- Sync revocations with `deploy-crl.sh`.

---

# Security Notes

- Always protect private keys with proper permissions.
- Keep your CA offline if possible.
- Use TLS-auth (ta.key) for additional control channel protection.
- Regularly update CRL on the server after revoking certificates.

---

# License

This setup and scripts assume you have knowledge of Linux, OpenVPN, and basic PKI operations. Use responsibly.

