# Elasticsearch and Kibana Lab Environment
Vagrant deployment of Elasticsearch and Kibana in a Linux VM running in Virtualbox.

- Elasticsearch: https://github.com/elastic/elasticsearch
- Kibana: https://github.com/elastic/kibana
- Reference instructions: https://github.com/elastic/elasticsearch?tab=readme-ov-file#run-elasticsearch-locally

## Requirements

- ### CPU and Memory
  The VM created by Vagrant/Virtualbox is an Ubuntu 22.04 LTS (Jammy Jellyfish) with 4 CPU cores and 4GB of RAM.
  Make sure your host machine has enough CPU cores and RAM memory to spare!

## Build Instructions
- Download this repository to a local directory in your machine.
- Navigate to the `elastic` directory and run `vagrant up`:
  ```bash
  $ cd elastic
  $ vagrant up
  ```
- If there were no errors, you should see the status report as follows:

  ***NOTE:** The server's IP address, as well as Elasticsearch/Kibana version, ports and passwords can be changed in [`elastic/Vagrantfile`](Vagrantfile).*

  ```txt
  default: ==============================
  default: Elasticsearch and Kibana Install SUCCESSFUL!
  default:
  default: Elasticsearch (version 8.15.1): http://192.168.56.15:9200
  default: Kibana URL (version 8.15.1): http://192.168.56.15:5601
  default:
  default: Username: elastic (for both Elastic and Kibana)
  default: Elasticsearch Password: elastic
  default: Kibana Password: elastic
  default:
  default: It may take a few minutes for all components to be fully responsive.
  default: ==============================
  ```

- To destroy the environment and start over, navigate to the `elastic` directory and run `vagrant destroy -f`:
  ```bash
  $ cd elastic
  $ vagrant destroy -f
  ==> default: Forcing shutdown of VM...
  ==> default: Destroying VM and associated drives...
  $
  ```
