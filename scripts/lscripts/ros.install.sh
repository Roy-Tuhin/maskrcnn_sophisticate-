#!/bin/bash

##----------------------------------------------------------
## ROS
##----------------------------------------------------------
# http://answers.ros.org/question/238763/how-to-install-kinetic-on-ubuntu-14/
# http://wiki.ros.org/kinetic/Installation
# http://wiki.ros.org/indigo/Installation/Ubuntu
## The Kinetic installation instructions clearly state that binary packages (apt-get) for ROS Kinetic are only available for Ubuntu Wily (15.10) and Xenial (16.04). I'd recommend that you use ROS Indigo instead (it is a long-term support release compatible with Ubuntu 14.04)

OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)
OS_CODE_NAME=$(lsb_release -sc)

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $OS_CODE_NAME main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update

ROSVER=''
case $OS in
  16.04)
    #16.04
    sudo apt -y install ros-kinetic-desktop-full
    ROSVER='kinetic'
    ;;
  14.04)
    #14.04
    sudo apt -y install ros-indigo-desktop-full
    ROSVER='indigo'
    ;;
  *)
    # leave as-is
    ;;
esac

sudo rosdep init
rosdep update
rosdep install rviz

sudo apt -y install python-rosinstall
sudo apt -y install ros-$(ROSVER)-image-view
sudo apt -y install ros-$(ROSVER)-stereo-image-proc0
