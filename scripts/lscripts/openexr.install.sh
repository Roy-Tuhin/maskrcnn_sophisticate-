#!/bin/bash

##----------------------------------------------------------
## PROJ
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/openexr/openexr
## OpenEXR is a high dynamic-range (HDR) image file format developed by Industrial Light & Magic for use in computer imaging applications.
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

sudo apt -y install libpng-dev libjpeg-dev libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev

PROG="openexr"
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/openexr/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  ## git clone --recurse-submodules -j8 $URL $PROG_DIR
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  # git checkout v2.3.0
else
  echo Git clone for $URL exists at: $PROG_DIR
fi


mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake ..
ccmake ..
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS


# cd $PROG_DIR/IlmBase
# ./bootstrap
# ./configure
# make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS

# cd $PROG_DIR/OpenEXR
# ./bootstrap
# ./configure
# make -j$NUMTHREADS
# # sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

# export ILMBASE_HOME=$HOME/softwares/openexr
# export OPENEXR_HOME=$HOME/softwares/openexr

# /usr/local/include/OpenEXR