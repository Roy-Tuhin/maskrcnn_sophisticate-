#!/bin/bash

##----------------------------------------------------------
## docker-compose
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.2
##----------------------------------------------------------
#
##
## https://docs.docker.com/compose/install/
## https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04
## https://linuxize.com/post/how-to-install-and-use-docker-compose-on-ubuntu-18-04/
## https://github.com/docker/compose/releases
#
##----------------------------------------------------------

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version

## Uninstallation
# sudo rm /usr/local/bin/docker-compose

# docker run --gpus all nvidia/cuda:9.0-devel nvidia-smi
# docker run --gpus all --rm nvidia/cuda nvidia-smi