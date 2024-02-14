#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install GCloud CLI
echo "=============================="
echo "Starting GCloud CLI Install..."
echo "=============================="

# Ref: https://cloud.google.com/sdk/docs/install#deb

# Import the Google Cloud Public Key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Add the gcloud CLI distribution URI as a package source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Update and install the gcloud CLI and Auth Plugin
apt-get -yqq update
apt-get -yqq install google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin

# Validate
su - vagrant -c "gcloud --version"
if test "${?}" -eq 0; then
  echo "=============================="
  echo "GCloud CLI Install SUCCESSFUL!"
  echo "You still need to set it up manually by running the command below:"
  printf "\n"
  echo "   gcloud init"
  printf "\n"
  echo "=============================="
else
  echo "=============================="
  echo "GCloud CLI Install FAILED!"
  echo "Either manually install it or restart the deployment process."
  echo "=============================="
  exit 1
fi
