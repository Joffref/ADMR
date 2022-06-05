#! /bin/bash
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get update
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates
sudo apt-get install isc-dhcp-server
sudo apt-get install vlan
sudo vconfig add eth0 1
sudo vconfig add eth0 2
sudo vconfig add eth0 3
sudo vconfig add eth0 4
sudo vconfig add eth0 5
sudo vconfig add eth0 6
# Peut etre mettre ça dans le fichier de configuration network
sudo ip addr add 192.168.10.0/24 dev eth0.1
sudo ip addr add 192.168.20.0/24 dev eth0.2
sudo ip addr add 192.168.30.0/24 dev eth0.3
sudo ip addr add 192.168.40.0/24 dev eth0.4
sudo ip addr add 192.168.50.0/24 dev eth0.5
sudo ip addr add 192.168.60.0/24 dev eth0.6