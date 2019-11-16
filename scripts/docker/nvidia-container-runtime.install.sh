#!/bin/bash

# https://github.com/NVIDIA/nvidia-container-runtime/issues/9

# https://nvidia.github.io/nvidia-docker/debian8/nvidia-docker.list
# https://nvidia.github.io/nvidia-docker/ubuntu16.04/nvidia-docker.list
# https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list

## https://nvidia.github.io/nvidia-container-runtime/
## https://docs.docker.com/config/containers/resource_constraints/

# curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
#   sudo apt-key add -
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
#   sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update

sudo apt install nvidia-container-runtime