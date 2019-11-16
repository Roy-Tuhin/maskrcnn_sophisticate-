#!/bin/bash

##----------------------------------------------------------
## lyx
## https://wiki.lyx.org/LyX/LyXOnUbuntu#toc3
##----------------------------------------------------------

#sudo apt --remove lyx
sudo add-apt-repository -y ppa:lyx-devel/release
sudo apt update
sudo apt install -y lyx

