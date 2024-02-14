#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install AWS CLI
echo "=============================="
echo "Starting AWS CLI Install..."
echo "=============================="

# curl -F didn't work.
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
su - vagrant -c "aws --version"
if test "${?}" -eq 0; then
  echo "=============================="
  echo "AWS CLI Install SUCCESSFUL!"
  echo "You still need to set it up according the URL below:"
  echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html"
  echo "=============================="

  # Remove both zipped and inflated Installer files
  rm -rf aws awscliv2.zip
else
  echo "=============================="
  echo "AWS CLI Install FAILED!"
  echo "Either manually install it or restart the deployment process."
  echo "=============================="
  exit 1
fi
