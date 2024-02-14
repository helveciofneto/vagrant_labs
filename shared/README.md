# Shared Scripts
This directory contains common scripts that are used to install and configure different products in each lab environment.

They are tweaked to run as part of a Vagrant deployment and may assume Vagrant-related settings (i.e. vagrant user, /home/vagrant, etc).

- ## `aws_cli.sh`
  Installs the AWS CLI V2 according to the following instructions: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.

  After the installation is complete, it's still necessary to manually set it up (credentials, region, etc) by following the instructions in this URL: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
- ## `gcloud_cli.sh`
  This script installs GCloud CLI as instructed here: https://cloud.google.com/sdk/docs/install#deb.

  After the installation completes, it is necessary to run `gcloud init` to connect to the appropriate Account/Project.

- ## `homebrew.sh`
  [Homebrew](https://brew.sh/) is a Mac and Linux Package Management utility that simplifies dependendcy handling. It is possible, for instance, to manage the instalation of `kubenctx/kubens` and `fzf` and their dependencies in a single command, without dealing with additional repository-related steps.
- ## `k3s.sh`
  K3s (https://k3s.io/) is a lightweight Kubernetes distribution. It is the basis of all Kubernetes-related labs in this repository.

  The script performs a simple install according to the official instructions and adjusts some file/directory ownership settings.
- ## `kustomize.sh`
  Kustomize (https://kustomize.io/) is a tool that manages a given Kubernetes configuration. It's primarily used as part of the AWX Lab install process, but was made available as a shared script for use in other labs as well.
