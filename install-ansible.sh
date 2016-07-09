#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "Updating system"
apt-get -qq update > /dev/null
apt-get -qq upgrade > /dev/null

echo "Installing Ansible dependencies"
apt-get -qq install build-essential libssl-dev libffi-dev python-dev python-pip sshpass rsync > /dev/null

echo "Installing Ansible"
pip install -qq --upgrade ansible

unset DEBIAN_FRONTEND
