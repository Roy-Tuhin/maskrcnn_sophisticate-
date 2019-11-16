#!/bin/bash

##----------------------------------------------------------
## OpenCV
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## http://www.linuxfromscratch.org/blfs/view/cvs/general/opencv.html
## http://www.bogotobogo.com/OpenCV/opencv_3_tutorial_ubuntu14_install_cmake.php
## https://ubuntuforums.org/showthread.php?t=2219550
## https://github.com/facebook/fbcunn/blob/master/INSTALL.md
## https://github.com/milq/milq/blob/master/scripts/bash/install-opencv.sh

## INSTALL DEPENDENCIES
sudo -E apt -q -y install build-essential cmake git unzip pkg-config qtbase5-dev
sudo -E apt -q -y install libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libopencv-dev

## python
#source ./python.install.sh

## ffmpeg install
#source ./ffmpeg.install.sh


sudo apt remove x264 libx264-dev
sudo apt -y install checkinstall yasm libjpeg8-dev libjasper-dev libpng12-dev libtiff5-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2-dev libv4l-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libqt4-dev libgtk-3-dev libgtk2.0-dev libtbb-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev x264 v4l-utils


sudo apt -y install doxygen doxygen-gui graphviz


# # https://www.learnopencv.com/installing-deep-learning-frameworks-on-ubuntu-with-cuda-support/
sudo apt remove x264 libx264-dev
sudo -E apt -q -y install checkinstall yasm
sudo -E apt -q -y install libjpeg8-dev libjasper-dev libpng12-dev
 
## If you are using Ubuntu 14.04
## sudo -E apt -q -y install libtiff4-dev
 
## If you are using Ubuntu 16.04
sudo -E apt -q -y install libtiff5-dev
sudo -E apt -q -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
 
sudo -E apt -q -y install libxine2-dev libv4l-dev
sudo -E apt -q -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo -E apt -q -y install libqt4-dev libgtk2.0-dev libtbb-dev
sudo -E apt -q -y install libfaac-dev libmp3lame-dev libtheora-dev
sudo -E apt -q -y install libvorbis-dev libxvidcore-dev
sudo -E apt -q -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo -E apt -q -y install x264 v4l-utils
