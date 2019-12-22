#!/bin/bash

##----------------------------------------------------------
## Pre-requisite
## To be Tested in Integrated way and sequence of installation to be determined
## on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
## currently, tried after `source geos.install.sh` in Ubuntu 18.04 LTS
#
##----------------------------------------------------------
#


function pre_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo -E apt -q -y install libxml2-dev
  # sudo -E apt -q -y install liblas-dev # some issue with libght
  sudo -E apt -q -y install libcunit1 libcunit1-dev

  sudo -E apt -q -y install lzma

  sudo -E apt -q -y install libmpich-dev
  sudo -E apt -q -y install libcgal-dev
  #
  sudo -E apt -q -y install libxerces-c-dev
  sudo -E apt -q -y install libjsoncpp-dev
  #
  sudo -E apt -q -y install libqt5x11extras5-dev
  sudo -E apt -q -y install qttools5-dev
  #
  sudo -E apt -q -y install libsuitesparseconfig4.4.6 libsuitesparse-dev
  sudo -E apt -q -y install metis libmetis-dev
  #
  sudo -E apt -q -y install maven
  sudo -E apt -q -y install openssh-server openssh-client
  sudo -E apt -q -y install libssl-dev libsslcommon2-dev
  sudo -E apt -q -y install pkg-config
  sudo -E apt -q -y install libglfw3 libglfw3-dev

  ## https://www.pyimagesearch.com/2015/08/24/resolved-matplotlib-figures-not-showing-up-or-displaying/
  ## https://github.com/tctianchi/pyvenn/issues/3
  sudo -E apt -q -y install tcl-dev tk-dev python-tk python3-tk
  #
  sudo -E apt -q -y install autoconf automake libtool curl unzip
  #
  ## ceres-solver dependencies
  sudo -E apt -q -y install libgflags2.2 libgflags-dev python-gflags python3-gflags libgoogle-glog-dev

  ## TBD: path fix for init
  source ${LSCRIPTS}/pcl.prerequisite.install.sh
  #
  source ${LSCRIPTS}/opencv.prerequisite.sh
  #

  # # ## Ubuntu 18.04 LTS

  # # Reading state information... Done
  # # E: Unable to locate package libflann1.8
  # # E: Couldn't find any package by glob 'libflann1.8'
  # # E: Couldn't find any package by regex 'libflann1.8'

  # # Package libvtk5-dev is not available, but is referred to by another package.
  # # This may mean that the package is missing, has been obsoleted, or
  # # is only available from another source
  # # However the following packages replace it:
  # #   libvtk7-dev:i386 libvtk6-dev:i386 libvtk7-dev libvtk6-dev

  # # E: Unable to locate package libvtk5.10-qt4
  # # E: Couldn't find any package by glob 'libvtk5.10-qt4'
  # # E: Couldn't find any package by regex 'libvtk5.10-qt4'
  # # E: Unable to locate package libvtk5.10
  # # E: Couldn't find any package by glob 'libvtk5.10'
  # # E: Couldn't find any package by regex 'libvtk5.10'
  # # E: Package 'libvtk5-dev' has no installation candidate
  # # Reading package lists... Done

  # # E: Package 'libpng12-dev' has no installation candidate
  # # E: Unable to locate package libgstreamer0.10-dev
  # # E: Couldn't find any package by glob 'libgstreamer0.10-dev'
  # # E: Couldn't find any package by regex 'libgstreamer0.10-dev'
  # # E: Unable to locate package libgstreamer-plugins-base0.10-dev
  # # E: Couldn't find any package by glob 'libgstreamer-plugins-base0.10-dev'
  # # E: Couldn't find any package by regex 'libgstreamer-plugins-base0.10-dev'

  # # Package libpng12-dev is not available, but is referred to by another package.
  # # This may mean that the package is missing, has been obsoleted, or
  # # is only available from another source

  # # E: Package 'libpng12-dev' has no installation candidate
}

pre_install
