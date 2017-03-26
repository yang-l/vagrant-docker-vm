#!/usr/bin/env bash

set -e

echo '==> Updating repositories'
apt-get -y update
apt-get -y dist-upgrade --force-yes

echo '==> Installing pip'

yes | apt-get -y --force-yes install --no-install-recommends build-essential python-dev python-pip libffi-dev libssl-dev git

echo '==> Installing ansible'

pip install ansible==2.2.1.0

echo '==> Running ansible playbook'
cd /tmp/ansible
ansible-galaxy install -r requirements.yml
