# Offline Certificate Authority (CA) Workflow

## Purpose
Manage all OpenVPN client/server certificates on an **offline machine**.  
Never expose your CA private key to the VPN server.

---

## Tools Used
- [easy-rsa](https://github.com/OpenVPN/easy-rsa) for PKI generation
- OpenSSL (optional)
- Manual USB transfer to server for certs and CRL

---

## Directory Structure (Example)
~/vpn-ca/ <br>
├── pki/ <br>
├── vars <br>
├── easy-rsa/ <br>
├── output/ <br>
├── server.crt <br>
├── server.key <br>
├── ca.crt <br>
├── client1.crt <br>
├── client1.key <br>
├── crl.pem <br>

---

## 1️ Initialize the CA
```bash
# Clone easy-rsa if you don't have it
git clone https://github.com/OpenVPN/easy-rsa.git ~/vpn-ca/easy-rsa

cd ~/vpn-ca/easy-rsa
cp vars.example vars

Edit vars for your org/CN if you like.
```

# Build PKI
```./easyrsa init-pki```

# Build the CA keypair
```./easyrsa build-ca```
Store ca.key securely — never copy it to the VPN server.


## 2️ Generate & Sign Server Cert
```bash
./easyrsa gen-req server-name nopass
./easyrsa sign-req server server-name
```
Copy server.crt, server.key, and ca.crt to the VPN server.

## 3️ Generate & Sign Client Certs
```bash
./easyrsa gen-req client-nick nopass
./easyrsa sign-req client client-nick
```

```client-nick.ovpn = ca.crt + client-nick.crt + client-nick.key + TLS config```


## 4 Revoke a Cert
```bash
./easyrsa revoke client-nick
./easyrsa gen-crl
```

## 5️ Best Practices
✅ Keep ca.key offline at all times.
✅ Backup pki/ and vars.
✅ Transfer only signed certs, not private keys.
✅ Regenerate CRL on any revocation.
✅ Use strong passphrases if not air-gapped.


## Scripts
See scripts/:

init-easyrsa.sh — initializes PKI.

sign-client-cert.sh — wraps gen-req + sign.

revoke-cert.sh — revokes and regenerates CRL.

deploy-crl.sh — syncs CRL to VPN server.

## References
[easy-rsa GitHub](https://github.com/OpenVPN/easy-rsa)

[OpenVPN PKI HOWTO](https://openvpn.net/community-resources/how-to/)