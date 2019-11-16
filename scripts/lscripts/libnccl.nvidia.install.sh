#!/bin/bash

##----------------------------------------------------------
#
### libnccl
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
## Nvidia GTX 1080 Ti, Driver version 390.42, CUDA 9.0, 9.1
#
## Tested on Ubuntu 18.04 LTS
## Nvidia GeForce 940MX, Deriver version 390, CUDA 9.0, 9.1 on Dell Latitude 5580
#
## https://docs.nvidia.com/deeplearning/sdk/nccl-install-guide/index.html
## pre-requisites:
##  * glibc 2.19 or higher
##  * CUDA 8.0 or higher
#
##----------------------------------------------------------


# sudo dpkg -i nccl-repo-<version>.deb
sudo dpkg -i $HOME/Downloads/nccl-repo-ubuntu1604-2.2.13-ga-cuda9.0_1-1_amd64.deb
sudo apt update
sudo apt -y install libnccl2 libnccl-dev
