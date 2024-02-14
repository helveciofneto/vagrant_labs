#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install K3s
echo "=============================="
echo "Starting K3s Install..."
echo "=============================="

su - vagrant -c 'curl -sfL https://get.k3s.io | sh -'
if test "${?}" -eq 0; then
  echo "=============================="
  echo "K3s Install SUCCESSFUL!"
  echo "=============================="

  # This ensures the owner is properly set for K3s, cri-o and other Rancher-related files.
  # This does not, however, allow to run crictl as a non-root user.
  chown -R vagrant:vagrant /etc/rancher
  chown -R vagrant:vagrant /var/lib/rancher

  # This is to ensure that tools like Helm can use the correct K3s settings.
  echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> .bashrc
  . .bashrc
else
  echo "=============================="
  echo "K3s Install FAILED!"
  echo "Either manually install it or restart the deployment process."
  echo "=============================="
  exit 1
fi
