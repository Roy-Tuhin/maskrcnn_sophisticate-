#!/bin/bash

##----------------------------------------------------------
### vokoscreen
##----------------------------------------------------------
# * https://www.unixmen.com/vokoscreen-a-new-screencasting-tool-for-linux/
# * https://www.lifewire.com/create-video-tutorials-using-vokoscreen-screencasting-3958725
# * https://github.com/vkohaupt/vokoscreen

sudo -E add-apt-repository -y ppa:vokoscreen-dev/vokoscreen
#sudo -E apt-add-repository --remove ppa:vokoscreen-dev/vokoscreen
sudo -E apt-get update
sudo -E apt-get -q -y install vokoscreen
