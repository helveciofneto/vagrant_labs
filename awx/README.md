# AWX Lab Environment
Vagrant and K3s config files for deploying AWX in a Linux VM running in Virtualbox.

AWX Project Repository: https://github.com/ansible/awx

This build is based on the instructions provided by **Calvin Remsburg** on YouTube: https://www.youtube.com/watch?v=Nvjo2A2cBxI
## Requirements
- ### CPU and Memory
  The VM created by Vagrant/Virtualbox is an Ubuntu 22.04 LTS (Jammy Jellyfish) with 4 CPU cores and 4GB of RAM. AWX is resource-intensive, and would struggle with anything less in a one-VM setup like this.

  Make sure your host machine has enough CPU cores and RAM memory to spare!
## Build Instructions
- Download this repository to a local directory in your machine.
- Navigate to the `awx` directory and run `vagrant up`:
  ```bash
  $ cd awx
  $ vagrant up
  ```
- If there were no errors, you should see the URL and AWX admin password as follows:
  ```txt
  default: AWX build complete!
  default: ==============================
  default: AWX URL: http://192.168.56.10:30080
  default: AWX admin password: <PASSWORD>
  default: ==============================
  ```
  ---
  ***NOTE:** Even after the build is complete, it may take up to 10 minutes for AWX to become responsive through the web browser.*

  ---
- To destroy the environment and start over, navigate to the `awx` directory and run `vagrant destroy -f`:
  ```bash
  $ cd awx
  $ vagrant destroy -f
  ==> default: Forcing shutdown of VM...
  ==> default: Destroying VM and associated drives...
  $
  ```
