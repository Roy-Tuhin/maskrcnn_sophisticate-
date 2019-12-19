#!/bin/bash

##----------------------------------------------------------
## 
## Pre-requisite checks on GPU
## 
## How do I find out the model of my graphics card?
##----------------------------------------------------------


function nvidia_ubuntu1804_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  # check for Graphics Hardware and System Architecture Details
  source ${LSCRIPTS}/utils/gpu.info.sh

  info "Using NVIDIA_DRIVER_VER: ${NVIDIA_DRIVER_VER}"

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    info "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${NVIDIA_DRIVER_VER}" ]; then
    NVIDIA_DRIVER_VER='430'
    info "Unable to get NVIDIA_DRIVER_VER, using default version: ${NVIDIA_DRIVER_VER}"
  fi

  ##----------------------------------------------------------
  ## Nvidia Graphics Card Driver Installation
  ## Tested on:
  ## - Dell Latitude 5580 Laptop: Ubuntu 18.04 LTS
  ## - Dell Desktop with Nvidia GTX 1080 Ti: Ubuntu 18.04 LTS
  ##----------------------------------------------------------

  sudo apt remove 'nvidia-*'
  sudo apt remove 'cuda*'
  sudo apt remove 'cudnn*'
  sudo apt remove 'nvidia*'

  sudo -E apt update
  ## sudo -E apt upgrade

  sudo sh -c 'echo "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/disable-nouveau.conf'

  sudo apt install nvidia-driver-${NVIDIA_DRIVER_VER}
  # sudo reboot

  # after successful Nvidia Driver installation
  # source ${LSCRIPTS}/nvidia-driver-info.sh

}

nvidia_ubuntu1804_install
