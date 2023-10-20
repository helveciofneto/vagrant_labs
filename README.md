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
