#!/bin/bash

##----------------------------------------------------------
### Graphics Toolsets
## Tested on Ubuntu 16.04
#
## BD: create a script to install selected packages from the pre-defined list and/or
## give user option to select which to install
#
##----------------------------------------------------------

source ./gimp.graphics.install.sh
source ./imagemagic.install.sh
source ./inkscape.graphics.install.sh
source ./krita.graphics.install.sh

sudo -E apt install -y darktable
sudo -E apt install -y digikam

## TBD to put in multimedia toolsets - video editors, plugins, video streaming
source ./ffmpeg.install.sh
source ./handbrake.video-transcoder.sh
source ./openshot.install.sh
source ./slowmovideo.install.sh
source ./obs-studio.videoediting.install.sh

# Video Players
source ./vlc.install.sh

# Screen recorders
source ./vokoscreen.screen-recorder.install.sh

##
source ./youtubedl.video.sh

## 3D
source ./makehuman.3d.install.sh
# source ./meshlab.install.sh

## CAD
source ./openscad.cad.install.sh