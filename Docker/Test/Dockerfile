FROM ubuntu:24.04

# Basic tools
RUN apt-get update && \
    apt-get install -y curl ca-certificates apt-transport-https git openvpn easy-rsa nftables iproute2 tini

# k3s binary
RUN curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.33.2%2Bk3s1/k3s && chmod +x /usr/local/bin/k3s

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl

# Clone your repo
RUN git clone https://github.com/HarounAhmad/vpn-secure-home-server.git /opt/vpn-secure-home-server
WORKDIR /opt/vpn-secure-home-server

VOLUME ["/etc/openvpn"]
VOLUME ["/var/lib/rancher/k3s"]
ENV KUBECONFIG=/etc/rancher/k3s/k3s.yaml

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
