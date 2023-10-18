#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install buildah
# curl -F didn't work.
apt-get -y install buildah

# Set docker.io as a registry so that build commands can resolve from Docker Hub.
echo 'unqualified-search-registries = ["docker.io"]' > '/etc/containers/registries.conf.d/00-unqualified-search-registries.conf'

echo "=============================="
echo "buildah Install complete!"
echo "=============================="
