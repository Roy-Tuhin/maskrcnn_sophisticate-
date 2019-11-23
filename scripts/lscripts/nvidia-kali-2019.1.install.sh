#!/bin/bash

##----------------------------------------------------------
## 
## Pre-requisite checks on GPU
## 
## How do I find out the model of my graphics card?
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

# check for Graphics Hardware and System Architecture Details
source $LINUX_SCRIPT_HOME/utils/gpu.info.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

##----------------------------------------------------------
## Nvidia Graphics Card Driver Installation
## Tested on:
## - Dell Latitude 5580 Laptop: Ubuntu 18.04 LTS
## - Dell Desktop with Nvidia GTX 1080 Ti: Ubuntu 18.04 LTS
##----------------------------------------------------------

sudo apt -s purge 'nvidia-*'
sudo apt -s purge 'cuda*'
sudo apt -s purge 'cudnn*'
sudo apt remove nvidia*

# sudo -E apt update
# sudo -E apt upgrade


sudo apt install -y ocl-icd-libopencl1 nvidia-driver nvidia-cuda-toolkit

## install graphics driver

sudo sh -c 'echo "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/disable-nouveau.conf'

NVIDIA_DRIVER_VER='390'
sudo apt install nvidia-driver-$NVIDIA_DRIVER_VER
sudo reboot

# after successful Nvidia Driver installation

source $LINUX_SCRIPT_HOME/nvidia-driver-info.sh

cd $HOME/Downloads
chmod +x NVIDIA-Linux-x86_64-430.14.run
sudo ./NVIDIA-Linux-x86_64-430.14.run


