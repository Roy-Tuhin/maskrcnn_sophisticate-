#!/bin/bash

##----------------------------------------------------------
### handbrake - Video Converter/transcoder
##----------------------------------------------------------
# * https://handbrake.fr/
# * https://github.com/HandBrake

sudo -E add-apt-repository -y ppa:stebbins/handbrake-releases
sudo -E apt update
sudo -E apt -q -y install handbrake handbrake-gtk handbrake-cli

