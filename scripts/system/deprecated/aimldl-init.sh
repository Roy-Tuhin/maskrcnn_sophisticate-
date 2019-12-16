#!/bin/bash

##----------------------------------------------------------
## New system build semi-automation script
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
## Inspired by linuxscripts
##----------------------------------------------------------

mkdir -p ${HOME}/softwares
sudo apt update
sudo apt install -y git

git clone https://github.com/mangalbhaskar/linuxscripts.git ${HOME}/softwares/linuxscripts

sudo mkdir -p /aimldl-cod
sudo chown -R $(id -un):$(id -gn) /aimldl-cod
git clone --recurse-submodules https://github.com/mangalbhaskar/aimldl.git /aimldl-cod


