# Shared Scripts
This directory contains common scripts that are used to install and configure different products in each lab environment.

They are tweaked to run as part of a Vagrant deployment and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

- ## `aws_cli.sh`
  Installs the AWS CLI V2 according to the following instructions: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.

  After the installation is complete, it's still necessary to manually set it up (credentials, region, etc) by following the instructions in this URL: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
- ## `k3s.sh`
  K3s (https://k3s.io/) is a lightweight Kubernetes distribution. It is the basis of all Kubernetes-related labs in this repository.

  The script performs a simple install according to the official instructions and adjusts some file/directory ownership settings.
- ## `kustomize.sh`
  Kustomize (https://kustomize.io/) is a tool that manages a given Kubernetes configuration. It's primarily used as part of the AWX Lab install process, but was made available as a shared script for use in other labs as well.
