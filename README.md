# Vagrant Labs
This repository contains a set of VM lab environments for different products and platforms.

Currently available products/platforms:
- [AWX](awx) - Upstream project for Ansible Controller in Ansible Automation Platform
- [K3s](k3s) - Lightweight Kubernetes

## Requirements
The VMs are managed in [VirtualBox](https://www.virtualbox.org/) through [Hashicorp Vagrant](https://www.vagrantup.com/), which allows them to be created/destroyed with a single command.

- ### Install Virtualbox
  - Website: https://www.virtualbox.org/
  - The most recent validated version is **`7.0.10`**. If you have an older version installed, consider upgrading it.
  ---
  ***IMPORTANT:** On Windows, ensure Virtualbox is installed in a path without special characters (e.g. `C:\virtualbox`).*

  ---
- ### Install Vagrant
  - Website: https://www.vagrantup.com/
  - Recommended install version is **`2.3.7`** (the VM images used in this repository aren't fully validated with the SSH changes implemented in version 2.4.0).
  - After the install is complete, run `vagrant --version` to confirm Vagrant was installed correctly:
    ```bash
    $ vagrant --version
    Vagrant 2.3.7
    $
    ```
- ### Install Vagrant Plugins
  - After Vagrant is installed, run `vagrant plugin install vagrant-vbguest vagrant-reload` in a Shell/PowerShell prompt:
    ```bash
    $ vagrant plugin install vagrant-vbguest vagrant-reload
    Installing the 'vagrant-vbguest' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-vbguest (0.31.0)'!
    Installing the 'vagrant-reload' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-reload (0.0.1)'!
    $
    ```
  ---
  ***NOTE:** On Windows, it may be necessary to reboot the system at this point.*

  ---

# Customizing your Vagrant Lab
As you become more familiar with each lab environment, you may want to add commands, scripts and data to taylor them to your needs.

To allow such customizations without breaking the integrity and upgradeability of the repository, each lab supports the creation of a subdirectory called `./etc/` that is intended to run additional `.rb` files/commands that are specific to your local system.

Everything that is added to a lab's `./etc/` remains on your local system and is never uploaded, so you don't need to worry about merge conflicts that prevent you from receiving updates.

All `.rb` files found in `./etc/` are automatically executed by the respective lab's `Vagrantfile` in alphabetical order. While other files such as `.sh` scripts aren't executed directly, they can be indirectly called from these `.rb` files though.

Some use cases include:
- Creating a folder sync to a path that only exists in your computer;
- Running a shared or custom Shell script or executable file;
- Declaring Environment Variables/Secrets to be consumed by your scripts/VMs without exposing them.

The following is an example of how `./etc/` can be used:

- `./etc/secrets.rb`
  ```ruby
  # In this file, a module is declared with two local constants, that will be called by "./etc/custom_settings.rb".
  # The contents of this file remain on your local computer.
  module Secrets
    USERNAME = "myUsername"
    PASSWORD = "myPassword"
  end
  ```

- `./etc/custom_settings.rb`
  ```ruby
  # This file extends the lab's Vagrantfile with custom actions that are only relevant in your local context.
  # Just like the first file, this also remains only on your local computer.

  # Include secrets from "./etc/secrets.rb":
  require_relative "secrets.rb"
  include Secrets

  Vagrant.configure("2") do |config|
    # Sync local directory:
    config.vm.synced_folder "/path/to/my/local/dir", "/home/vagrant/localdir", type: "virtualbox"

    # Run a shared script:
    config.vm.provision "shell", path: "../shared/aws_cli.sh"

    # Run a custom script with the included secrets:
    config.vm.provision "shell",
      path: "./etc/custom_script.sh",
      env: {"USERNAME" => Secrets::USERNAME,
            "PASSWORD" => Secrets::PASSWORD}
  end
  ```
