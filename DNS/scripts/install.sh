#! /bin/bash
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y update
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates
wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --claim-token {} --claim-url https://app.netdata.cloud --non-interactive
sudo apt-get -y install dnsmasq 
sudo mv dnsmasq.conf /etc/dnsmasq.conf
sudo mv dnsmasq-hosts.conf /etc/dnsmasq-hosts.conf
sudo mv dnsmasq-dns.conf /etc/dnsmasq-dns.conf
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo systemctl enable dnsmasq