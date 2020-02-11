#!/bin/bash


##----------------------------------------------------------
### version - version variables for the installed softwares
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
## https://www.blender.org/
## http://ubuntuhandbook.org/index.php/2016/10/install-blender-2-78-in-ubuntu-16-04-14-04/
## https://www.blender.org/download/Blender2.81/blender-2.81a-linux-glibc217-x86_64.tar.bz2/
##----------------------------------------------------------

sudo add-apt-repository -y ppa:thomas-schiex/blender
sudo apt-get update
sudo apt-get install -y blender

#sudo apt install ppa-purge && sudo ppa-purge ppa:thomas-schiex/blender
