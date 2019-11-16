#!/bin/bash

##----------------------------------------------------------
### VLC
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
sudo -E apt update
sudo -E apt -q -y install vlc browser-plugin-vlc

# VLC hacks

##----------------------------------------------------------
### Opening the CAM out of the box
##----------------------------------------------------------
# vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio
