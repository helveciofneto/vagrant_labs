#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install Ansible CLI
echo "=============================="
echo "Starting Ansible Install..."
echo "=============================="
su - vagrant -c 'python3 -m pip install --upgrade pip --user'
su - vagrant -c 'python3 -m pip install ansible-lint --user'
su - vagrant -c 'python3 -m pip install pypsrp --user'
su - vagrant -c 'ansible-galaxy collection install community.general'
su - vagrant -c 'ansible-galaxy collection install community.windows'
echo "=============================="
echo "Ansible Install SUCCESSFUL! "
echo "=============================="
