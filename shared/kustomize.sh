#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install Kustomize
echo "=============================="
echo "Starting Kustomize Install..."
echo "=============================="

su - vagrant -c 'curl -s https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh | bash'
if test "${?}" -eq 0; then
  echo "=============================="
  echo "Kustomize Install SUCCESSFUL!"
  echo "=============================="
  mv kustomize /usr/local/bin
else
  echo "=============================="
  echo "Kustomize Install FAILED!"
  echo "Either manually install it or restart the deployment process."
  echo "=============================="
  exit 1
fi
