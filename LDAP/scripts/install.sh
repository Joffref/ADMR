#! /bin/bash
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get update -y
sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install slapd ldap-utils
sudo mv ldap.conf /etc/ldap/ldap.conf
