#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

##----------------------------------------------------------
## Graphics, Multimedia
##----------------------------------------------------------

source $LSCRIPTS/vlc.install.sh
source $LSCRIPTS/ffmpeg.install.sh
## source $LSCRIPTS/imagemagic.graphics.install.sh
source $LSCRIPTS/inkscape.graphics.install.sh
source $LSCRIPTS/gimp.graphics.install.sh
