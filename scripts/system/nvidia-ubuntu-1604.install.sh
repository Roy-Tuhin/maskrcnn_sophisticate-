#!/bin/bash

##----------------------------------------------------------
## 
## Pre-requisite checks on GPU
## 
## How do I find out the model of my graphics card?
##----------------------------------------------------------
lspci  -v -s  $(lspci | grep VGA | cut -d" " -f 1)
lspci | grep VGA
lspci | grep -i nvidia
sudo lswh -c video


if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

# check for Graphics Hardware and System Architecture Details
source $LINUX_SCRIPT_HOME/gpu.info.sh

##----------------------------------------------------------
## Nvidia Graphics Card Driver Installation
## Tested on:
## - Tested on Ubuntu 16.04 on Desktop
##----------------------------------------------------------

if [ -z "$NVIDIA_DRIVER_VER" ]; then  
  NVIDIA_DRIVER_VER='387.22'
  NVIDIA_DRIVER_VER='390.42'
  echo "Unable to get NVIDIA_DRIVER_VER version, falling back to default version#: $NVIDIA_DRIVER_VER"
fi

echo "Driver Installation should happen from virtual console i.e. ALT+F1"
echo ""
sudo service lightdm stop
sudo sh -c 'echo "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/disable-nouveau.conf'

sudo apt-get -s purge 'nvidia-*'
sudo apt-get -s purge 'cuda*'
sudo apt-get -s purge 'cudnn*'
sudo apt-get remove nvidia*
#sudo apt-get -y autoremove
# sudo stop gdm
# sudo stop kdm
# sudo stop lightdm

apt-get -s purge $(dpkg -l | awk '$2~/nvidia/ {print $2}')

## 1> apt-get repository based installation
## i found it more complicated and error prone

## 2> Run File based installation - best suited and successful method
## Download appropriate Driver
# http://us.download.nvidia.com/XFree86/Linux-x86_64/387.22/NVIDIA-Linux-x86_64-387.22.run

# Manually search the Driver version
#http://www.nvidia.com/Download/index.aspx?lang=en-us


DRIVERFILE='NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VER.run'
echo "Driver file: $HOME/Downloads/$DRIVERFILE"

chmod +x $HOME/Downloads/$DRIVERFILE
sudo sh $HOME/Downloads/$DRIVERFILE

# 3> Along with cudatoolkit installation - if the above 2 does not work, this works
## Refer: cuda.install.sh and cuda.config.sh

sudo reboot

# after successful Nvidia Driver installation

source $LINUX_SCRIPT_HOME/nvidia-driver-info.sh

