#! /bin/bash

# Please note that this script is tweaked to run as part of a Vagrant deployment
# and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

# Install Homebrew
echo "=============================="
echo "Starting Homebrew Install..."
echo "=============================="

# ref: https://docs.brew.sh/Installation#unattended-installation
su - vagrant -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Update .bashrc:
# Because this script is running under root and homebrew was installed under vagrant,
# The shellenv needs to be run before each "brew" command call.
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vagrant/.bashrc
su - vagrant -c 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew --version'

if test "${?}" -eq 0; then
  # Brew recommends the installation of GCC.
  su - vagrant -c 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install gcc'

  echo "=============================="
  echo "Homebrew Install SUCCESSFUL!"
  echo "=============================="
else
  echo "=============================="
  echo "Homebrew Install FAILED!"
  echo "Either manually install it or restart the deployment process."
  echo "=============================="
  exit 1
fi
