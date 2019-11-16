#!/bin/bash

##----------------------------------------------------------
## nvidia-container-runtime
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.2
##----------------------------------------------------------
#
## https://github.com/NVIDIA/nvidia-docker/issues/1035
## The recommended solution is to update to docker 19.03 and install nvidia-container-toolkit.

## https://github.com/NVIDIA/nvidia-docker/tree/master
## https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#requirements
## https://hub.docker.com/r/nvidia/cuda/

#
## https://nvidia.github.io/nvidia-container-runtime/

## https://nvidia.github.io/nvidia-docker/debian8/nvidia-docker.list

## deb https://nvidia.github.io/libnvidia-container/debian8/$(ARCH) /
## deb https://nvidia.github.io/nvidia-container-runtime/debian8/$(ARCH) /
## deb https://nvidia.github.io/nvidia-docker/debian8/$(ARCH) /


## https://nvidia.github.io/nvidia-docker/ubuntu16.04/nvidia-docker.list

## deb https://nvidia.github.io/libnvidia-container/ubuntu16.04/$(ARCH) /
## deb https://nvidia.github.io/nvidia-container-runtime/ubuntu16.04/$(ARCH) /
## deb https://nvidia.github.io/nvidia-docker/ubuntu16.04/$(ARCH) /


## https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list

## deb https://nvidia.github.io/libnvidia-container/ubuntu18.04/$(ARCH) /
## deb https://nvidia.github.io/nvidia-container-runtime/ubuntu18.04/$(ARCH) /
## deb https://nvidia.github.io/nvidia-docker/ubuntu18.04/$(ARCH) /

#
##----------------------------------------------------------

# distribution=debian8
# distribution=ubuntu16.04
# distribution=ubuntu18.04

id=$(. /etc/os-release;echo $ID)
version_id=$(. /etc/os-release;echo $VERSION_ID)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

if [[ $id == 'kali' ]]; then
  distribution=ubuntu18.04
fi

curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt update

# sudo apt -y install nvidia-container-runtime

## Docker 19.03 
sudo apt -y install nvidia-container-toolkit

sudo systemctl restart docker