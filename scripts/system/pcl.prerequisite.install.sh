#!/bin/bash

##----------------------------------------------------------
### PCL Pre-requisite
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
# http://pointclouds.org/downloads/linux.html
## As binaries
# sudo add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl
# sudo apt update
# sudo apt -y install libpcl-all
#
#-------------------------
## Setup Prerequisites
# https://larrylisky.com/2016/11/03/point-cloud-library-on-ubuntu-16-04-lts/
#-------------------------
#
sudo -E apt update
sudo -E apt -q -y install git build-essential linux-libc-dev
sudo -E apt -q -y install cmake cmake-gui 
sudo -E apt -q -y install libusb-1.0-0-dev libusb-dev libudev-dev
sudo -E apt -q -y install mpi-default-dev openmpi-bin openmpi-common  

##Ubuntu 16.04 LTS
# sudo -E apt -q -y install libflann1.8 libflann-dev

##Ubuntu 18.04 LTS
sudo -E apt -q -y install libflann1.9 libflann-dev

sudo -E apt -q -y install libeigen3-dev
sudo -E apt -q -y install libboost-all-dev

##Ubuntu 16.04 LTS
# sudo -E apt -q -y install libvtk5.10-qt4 libvtk5.10 libvtk5-dev

#Ubuntu 18.04 LTS
sudo -E apt -q -y install libvtk7.1 libvtk7-dev libvtk7.1-qt libvtk7-qt-dev libvtk7-java libvtk7-jni

sudo -E apt -q -y install libqhull* libgtest-dev
sudo -E apt -q -y install freeglut3-dev pkg-config
sudo -E apt -q -y install libxmu-dev libxi-dev 
sudo -E apt -q -y install mono-complete
#-------------------------
