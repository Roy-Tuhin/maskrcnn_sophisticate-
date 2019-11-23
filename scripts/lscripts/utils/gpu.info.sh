#!/bin/bash

##----------------------------------------------------------
## GPU / Graphics card
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

#source $LSCRIPTS/linuxscripts.config.sh

## How do I find out the model of my graphics card?

# check for Graphics Hardware and System Architecture Details
sudo lshw | grep -A10 "VGA\|3D"
lspci -nnk | grep -i "VGA\|3D" -A3
lspci -v -s $(lspci | grep VGA | cut -d" " -f 1)
lspci | grep VGA
lspci | grep -i nvidia
arch
glxinfo | grep OpenGL
sudo lshw -c video
