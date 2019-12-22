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


function init_new_system_installer() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ##----------------------------------------------------------
  ## Nvidia GPU Drivers, CUDA, cuDNN, TensorRT
  ##----------------------------------------------------------

  source ${LSCRIPTS}/init-nvidia.sh

  ##----------------------------------------------------------
  ## Utilities
  ##----------------------------------------------------------
  source ${LSCRIPTS}/init-utilities.sh

  ##----------------------------------------------------------
  ## Graphics, Multimedia
  ##----------------------------------------------------------
  source ${LSCRIPTS}/init-graphics-multemedia.sh

  #---------------------------------------------------------
  # Dependencies for software builds like:pcl,opencv etc.
  #----------------------------------------------------------
  source ${LSCRIPTS}/pre.install.sh

  ##----------------------------------------------------------
  ## GIS and Databases
  ##----------------------------------------------------------
  source ${LSCRIPTS}/init-gis.sh

  ##----------------------------------------------------------
  ## Android - SDK, NDK
  ##----------------------------------------------------------
  ## Install Manually:
  ## $HOME/android/sdk/ndk-bundle


  ##----------------------------------------------------------
  ## Deep Learning Frameworks
  ## For GPU based: Install Nvidia Drive
  ##----------------------------------------------------------
  source ${LSCRIPTS}/init-deeplearning.sh

  ##----------------------------------------------------------
  ## Photogrammetry pipeline Tools
  ##----------------------------------------------------------
  source ${LSCRIPTS}/init-photogrammetry.sh


  ##----------------------------------------------------------
  ## Video Editor, YouTube Downloader
  ##----------------------------------------------------------
  source ${LSCRIPTS}/init-videoutils.sh

  # ##----------------------------------------------------------
  # ## Optional
  # ##----------------------------------------------------------
  # source ${LSCRIPTS}/wine.install.sh
}

init_new_system_installer
