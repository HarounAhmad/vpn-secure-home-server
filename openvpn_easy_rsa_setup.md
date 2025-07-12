# OpenVPN Easy-RSA Setup (Arch Linux + Docker)

## 1️ Prep on Host

### Install Easy-RSA and OpenVPN
```bash
sudo pacman -S easy-rsa openvpn
```

### Create CA workspace
```bash
mkdir ~/vpn-ca
cd ~/vpn-ca
cp /etc/easy-rsa/vars .
```

### Initialize PKI
```bash
easyrsa init-pki
```

### Build CA
```bash
easyrsa build-ca nopass
```

### Generate server request
```bash
easyrsa gen-req server nopass
```

### Sign server cert
```bash
easyrsa sign-req server server
```

### Generate client request
```bash
easyrsa gen-req test-client nopass
easyrsa sign-req client test-client
```

### Generate CRL
```bash
easyrsa gen-crl
```

### Generate ta.key
```bash
openvpn --genkey secret ta.key
```

### Copy results to test folder
```bash
mkdir -p ~/vpn-test/pki/issued ~/vpn-test/pki/private ~/vpn-test/ccd
cp pki/ca.crt ~/vpn-test/
cp pki/issued/server.crt ~/vpn-test/pki/issued/
cp pki/private/server.key ~/vpn-test/pki/private/
cp pki/issued/test-client.crt ~/vpn-test/
cp pki/private/test-client.key ~/vpn-test/
cp crl.pem ~/vpn-test/
cp ta.key ~/vpn-test/
```

### Add CCD static IP mapping
```bash
echo "ifconfig-push 10.8.0.20 255.255.255.0" > ~/vpn-test/ccd/test-client
```

### Define Admin and Guest Clients

#### Purpose
Use unique cert CNs, static VPN IPs, and nftables to enforce different access levels.

####  Generate different certs
```bash
# Admin cert
easyrsa gen-req admin-nick nopass
easyrsa sign-req client admin-nick

# Guest cert
easyrsa gen-req guest-minecraft nopass
easyrsa sign-req client guest-minecraft
```
Copy them:
```bash
cp pki/issued/admin-nick.crt ~/vpn-test/
cp pki/private/admin-nick.key ~/vpn-test/
cp pki/issued/guest-minecraft.crt ~/vpn-test/
cp pki/private/guest-minecraft.key ~/vpn-test/
```

####  Map static IPs in CCD
```bash
echo "ifconfig-push 10.8.0.10 255.255.255.0" > ~/vpn-test/ccd/admin-nick
echo "ifconfig-push 10.8.0.20 255.255.255.0" > ~/vpn-test/ccd/guest-minecraft
```

####  nftables per-client rules example `/etc/nftables/per-client-rules.nft`
```nft
# Admin client: full LAN
ip saddr 10.8.0.10 accept

# Guest client: only Minecraft
ip saddr 10.8.0.20 ip daddr 192.168.0.46 tcp dport 25565 accept
ip saddr 10.8.0.20 ip daddr 192.168.0.46 udp dport 25565 accept
```

####  Confirm server.conf includes
```conf
client-config-dir /etc/openvpn/ccd
ccd-exclusive
```

---

## 2️ Run Ubuntu container (server)
```bash
docker run --name vpn-server \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -p 1194:1194/udp \
  -v ~/vpn-test:/etc/openvpn \
  -it ubuntu bash
```
Inside:
```bash
apt update && apt install -y openvpn iproute2
ls /dev/net/tun
openvpn --config /etc/openvpn/server.conf
```

---

## 3️ Connect client (host)

```conf
client
dev tun
proto udp
remote 127.0.0.1 1194
resolv-retry infinite
nobind
persist-key
persist-tun

ca /home/YOURUSER/vpn-test/ca.crt
cert /home/YOURUSER/vpn-test/admin-nick.crt  # Or guest-minecraft.crt
key /home/YOURUSER/vpn-test/admin-nick.key   # Or guest-minecraft.key
tls-crypt /home/YOURUSER/vpn-test/ta.key

cipher AES-256-GCM
auth SHA512
remote-cert-tls server
verb 3
```

Run:
```bash
sudo openvpn --config client.ovpn
```
 Tunnel comes up:
```
VERIFY OK
TUN/TAP device tun0 opened
Initialization Sequence Completed
```


### NOTE
if openvpn has issues when restarting or starting with systemd it is likely that openvpn is looking for a config in /etc/openvpn/server, and the current config is in /etc/openvpn.
to mitigate this just move the config to the server folder
