#!/usr/bin/env bash

echo "Updating system"
DEBIAN_FRONTEND=noninteractive apt-get -qq update > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade > /dev/null

echo "Installing Ansible dependencies" && \
  DEBIAN_FRONTEND=noninteractive apt-get -qq install build-essential libssl-dev libffi-dev python-dev python-pip > /dev/null
echo "Installing Ansible" && \
  pip install -qq --upgrade ansible

echo "Configuring hosts"
cat >> /etc/hosts <<EOL

# Vagrant environment nodes
192.168.50.10  manager
192.168.50.20  ruby deploy-ruby
192.168.50.21  php deploy-php
EOL

echo "Configuring SSH"
DEBIAN_FRONTEND=noninteractive apt-get -qq install sshpass > /dev/null
ssh-keyscan 192.168.50.20 192.168.50.21 manager ruby php deploy-ruby deploy-php >> /home/vagrant/.ssh/known_hosts
ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/id_rsa -q -P ""
cat >> /home/vagrant/.ssh/config <<EOL
Host php
  HostName php
  User administrator
  IdentityFile ~/ansible/host_vars/keys/administrator.php.rsa

Host ruby
  Hostname ruby
  User administrator
  IdentityFile ~/ansible/host_vars/keys/administrator.ruby.rsa

Host deploy-php
  HostName php
  User deployer
  IdentityFile ~/ansible/host_vars/keys/deployer.php.rsa

Host deploy-ruby
  Hostname ruby
  User deployer
  IdentityFile ~/ansible/host_vars/keys/deployer.ruby.rsa
EOL
chown -R vagrant:vagrant /home/vagrant/.ssh/*
chmod -R 600 /home/vagrant/.ssh/*

