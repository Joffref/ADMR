#! /bin/bash
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get update -y
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates
wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh  --claim-token {} --claim-url https://app.netdata.cloud --non-interactive
sudo apt-get -y install isc-dhcp-server
sudo apt-get -y install vlan
sudo mv isc-dhcp-server /etc/default/isc-dhcp-server
sudo mv dhcpd.conf /etc/dhcp/dhcpd.conf
sudo mv netconf.service /etc/systemd/system/netconf.service
sudo systemctl enable netconf

