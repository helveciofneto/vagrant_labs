#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install Helm
# ref: https://helm.sh/docs/intro/install/#from-script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
su - vagrant -c "helm version"
if test "${?}" -ne 0; then
  echo "=============================="
  echo "Helm Install FAILED!"
  echo "Either manually install it or restart the deployment process."
  echo "=============================="
  exit 1
else
  echo "=============================="
  echo "Helm Install SUCCESSFUL!"
  echo "=============================="

  # Remove downloaded installer script
  rm -f get_helm.sh
fi
