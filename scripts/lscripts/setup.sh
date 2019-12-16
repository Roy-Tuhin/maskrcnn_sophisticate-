#!/bin/bash

function system_setup() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## based on dockerfile builds
  source ${LSCRIPTS}/essential.sh

  ##3. Copy softwares from `samba5/softwares/packages-for-new-system-install` to local system under `$HOME/Downloads` manually, or use `rsync`
  #
  #smbuser="xxxxx"
  #smbserver="xx.x.xx.121"
  #remotepath="/data/samba/software/packages-for-new-system-install"
  #rsync -r ${smbuser}@${smbserver}:${remotepath} ${HOME}/Downloads

  ##----------------------------------------------------------
  ## Steps for system setup - to be executed in given sequence
  ##----------------------------------------------------------
  # 1. Nvidia GPU Driver installation - skip if pre-installed
  # - system re-boot required
  # 2. CUDA, CUDNN and related packages
  # 3. Sytem utilities and other software packages
  ##----------------------------------------------------------



  ##----------------------------------------------------------
  ## 1. Nvidia GPU Driver installation - skip if pre-installed
  # - system re-boot required
  ##----------------------------------------------------------

  ## If drivers are pre-install, skip this step
  ## Manual Installation of Nvidia Drivers is preferred!

  ## WARNING: the script will remove any pre-installed nvidia packages
  # source ${LSCRIPTS}/init-nvidia.sh


  ##----------------------------------------------------------
  ## 2. CUDA, CUDNN and related packages
  ##----------------------------------------------------------

  ## Nvidia GPU Drivers should be pre-installed
  ## Refer init-nvidia.sh

  source ${LSCRIPTS}/cuda.install.sh
  source ${LSCRIPTS}/cudnn.install.sh
  source ${LSCRIPTS}/tensorRT.install.sh

  ##----------------------------------------------------------
  ## 3. Sytem utilities and other software packages
  ##----------------------------------------------------------

  ##----------------------------------------------------------
  ## Install Essential utilities
  ##----------------------------------------------------------
  source ${LSCRIPTS}/pre.lite-install.sh
  source ${LSCRIPTS}/utils.core.install.sh

  ## Set the git 
  # git config user.email "you@example.com"
  # git config user.name "Your Name"
}

system_setup
