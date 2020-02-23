#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive


echo "Updating system"
apt-get -qq update > /dev/null
apt-get -qq upgrade > /dev/null


echo "Installing Ansible official repository"
apt-get -qq install dirmngr > /dev/null
echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' > /etc/apt/sources.list.d/ansible.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 2>/dev/null
apt-get -qq update > /dev/null


echo "Installing Ansible"
apt-get -qq install ansible python-pip python-jmespath sshpass rsync > /dev/null
pip install --system --quiet ansible-lint


unset DEBIAN_FRONTEND
