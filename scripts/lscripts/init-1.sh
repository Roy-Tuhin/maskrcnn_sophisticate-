#!/bin/bash

##----------------------------------------------------------
### New system build semi-automation script
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## TBD:
# 1. taking user inputs from keyboard or from config file
##----------------------------------------------------------

## Set the git 
# git config --global user.email "you@example.com"
# git config --global user.name "Your Name"

LSCRIPTS=$(pwd)
export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

##----------------------------------------------------------
## Nvidia GPU Drivers, CUDA, cuDNN, TensorRT
##----------------------------------------------------------
cd $LSCRIPTS

##----------------------------------------------------------
## Nvidia GPU Drivers
##----------------------------------------------------------

## Ubuntu 16.04 LTS
## Install in Virtual Console
if [[ $LINUX_VERSION == "16.04" ]]; then
  echo "...$LINUX_VERSION"
  source $LSCRIPTS/nvidia-ubuntu-1604.install.sh
fi

# Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  echo $LINUX_VERSION
  source $LSCRIPTS/nvidia-ubuntu-1804.install.sh
fi

source init-nvidia.sh

##----------------------------------------------------------
## Utilities
##----------------------------------------------------------
cd $LSCRIPTS
source init-utilities.sh

##----------------------------------------------------------
## Graphics, Multimedia
##----------------------------------------------------------
cd $LSCRIPTS
source init-graphics-multemedia.sh

#---------------------------------------------------------
# Dependencies for software builds like:pcl,opencv etc.
#----------------------------------------------------------
cd $LSCRIPTS
source pre.install.sh

