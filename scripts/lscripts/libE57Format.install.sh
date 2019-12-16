#!/bin/bash

##----------------------------------------------------------
## libE57Format
## Tested on Ubuntu Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/asmaloney/libE57Format
## A library to provide read & write support for the E57 file format.
#
## This is a fork of E57RefImpl v1.1.332. It is primarily for use in the CloudCompare project, but it should work for anyone else who wants to use it.
#
## https://github.com/ryanfb/e57tools
## This repository contains tools for working with E57 format 3D data, based on libE57Format.
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

DIR="libE57Format"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/asmaloney/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Gid clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake -D CMAKE_BUILD_TYPE=RELEASE ..

### not required
## ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME
