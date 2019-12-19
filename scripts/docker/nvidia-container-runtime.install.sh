#!/bin/bash

# https://github.com/NVIDIA/nvidia-container-runtime/issues/9

# https://nvidia.github.io/nvidia-docker/debian8/nvidia-docker.list
# https://nvidia.github.io/nvidia-docker/ubuntu16.04/nvidia-docker.list
# https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list

## https://nvidia.github.io/nvidia-container-runtime/
## https://docs.docker.com/config/containers/resource_constraints/

function nvidia_container_runtime_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  # curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  #   sudo apt-key add -
  # distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  # curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  #   sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

  curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | \
    sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update

  sudo apt -y install nvidia-container-runtime

  ## configure nvidia-container-runtime
  source ${LSCRIPTS}/nvidia-container-runtime.docker.config.sh

  nvidia-container-runtime --version
}

nvidia_container_runtime_install
