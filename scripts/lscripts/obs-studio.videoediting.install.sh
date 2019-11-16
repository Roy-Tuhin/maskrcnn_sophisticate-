#!/bin/bash

##----------------------------------------------------------
### obs-studio
# https://obsproject.com/
# https://github.com/obsproject/obs-studio/wiki/Install-Instructions#linux
##----------------------------------------------------------

## obs-studio
sudo -E add-apt-repository -y ppa:obsproject/obs-studio
sudo -E apt-get update
sudo -E apt -q -y install obs-studio
