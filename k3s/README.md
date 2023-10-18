# K3s Lab Environment
Vagrant deployment of K3s in a Linux VM running in Virtualbox.

K3s Project Repository: https://github.com/k3s-io/k3s

## Requirements
- ### CPU and Memory
  The VM created by Vagrant/Virtualbox is an Ubuntu 22.04 LTS (Jammy Jellyfish) with 4 CPU cores and 4GB of RAM.
  Make sure your host machine has enough CPU cores and RAM memory to spare!
## Build Instructions
- Download this repository to a local directory in your machine.
- Navigate to the `k3s` directory and run `vagrant up`:
  ```bash
  $ cd k3s
  $ vagrant up
  ```
- If there were no errors, you should see the status report as follows:
  ```bash
  default: ==============================
  default: K3s build complete!
  default: ==============================
  ```
- To destroy the environment and start over, navigate to the `k3s` directory and run `vagrant destroy -f`:
  ```bash
  $ cd k3s
  $ vagrant destroy -f
  ==> default: Forcing shutdown of VM...
  ==> default: Destroying VM and associated drives...
  $
  ```
