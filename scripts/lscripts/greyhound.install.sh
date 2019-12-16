#!/bin/bash

##----------------------------------------------------------
## Greyhound
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/hobu/greyhound
#
## A point cloud streaming framework for dynamic web services and native applications.
#
##----------------------------------------------------------
#
## Prior to installing natively, you must first install PDAL and its dependencies, and then install Entwine. Then you can install Greyhound via NPM.
##----------------------------------------------------------
# npm install -g greyhound-server
# greyhound


## build is failing as per github
source ./lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS
DIR="greyhound"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/hobu/$DIR.git"

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
cmake ..
ccmake ..
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS


##----------------------------------------------------------
## Build Error Logs
##----------------------------------------------------------

# https://github.com/hobu/greyhound/issues/68

# [ 85%] Building CXX object greyhound/CMakeFiles/app.dir/resource.cpp.o
# /home/game1/softwares/greyhound/greyhound/resource.cpp:9:10: fatal error: entwine/types/manifest.hpp: No such file or directory
#  #include <entwine/types/manifest.hpp>
#           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Install: https://github.com/eidheim/Simple-Web-Server

# CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
# Please set them or make sure they are set and tested correctly in the CMake files:
# SIMPLE_WEB_SERVER_INCLUDE_DIR
#    used as include directory in directory /home/game1/softwares/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound/greyhound
#    used as include directory in directory /home/game1/softwares/greyhound/greyhound