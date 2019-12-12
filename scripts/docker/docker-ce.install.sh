#!/bin/bash

##----------------------------------------------------------
### docker-ce
## Tested on Ubuntu Ubuntu 18.04 LTS
#
## https://docs.docker.com/install/linux/docker-ce/ubuntu/#prerequisites
## https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
#
##----------------------------------------------------------

## uninstall
sudo apt -y remove docker docker-engine docker.io
sudo apt update
## Install packages to allow apt to use a repository over HTTPS:
sudo apt -q -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

## Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#
## Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88
#
## Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or test repositories as well.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
#
## List the versions available in your repo
apt-cache madison docker-ce
##  Install a specific version by its fully qualified package name, which is package name (docker-ce) “=” version string (2nd column), for example, docker-ce=18.03.0~ce-0~ubuntu.
# sudo apt-get install docker-ce=<VERSION>
#
##  installs the highest possible version
sudo -E apt -q -y install docker-ce
#
## Verify that Docker CE is installed correctly by running the hello-world image
sudo docker run hello-world

# ##----------------------------------------------------------
# #
# ## **Configuration as non-root**
# ##https://docs.docker.com/install/linux/linux-postinstall/
# ##----------------------------------------------------------
 

sudo groupadd docker
# sudo usermod -aG docker $USER
sudo gpasswd -a $USER docker
# newgrp docker

# #
## sudo reboot
# ## verify
docker run hello-world
