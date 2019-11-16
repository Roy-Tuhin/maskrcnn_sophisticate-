#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

##----------------------------------------------------------
## Video Editor, YouTube Downloader
##----------------------------------------------------------
source $LSCRIPTS/handbrake.video-transcoder.sh
source $LSCRIPTS/obs-studio.videoediting.install.sh
source $LSCRIPTS/slowmovideo.install.sh
source $LSCRIPTS/youtubedl.video.sh
#
source $LSCRIPTS/flatpak.install.sh
source $LSCRIPTS/pitvi.video-editor.install.sh

# blender - manual download