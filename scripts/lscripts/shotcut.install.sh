#!/bin/bash

##----------------------------------------------------------
### shotcut
# Video Editor
##----------------------------------------------------------
# https://shotcut.org/download/

source lscripts.config.sh


FILE="shotcut-linux-x86_64-180801.tar.bz2"
## wget -c https://github.com/mltframework/shotcut/releases/download/v18.08/$FILE -P $HOME/Downloads

tar xvfj $HOME/Downloads/$FILE -C $BASEPATH #verbose
