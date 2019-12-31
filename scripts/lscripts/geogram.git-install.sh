#!/bin/bash
##----------------------------------------------------------
# AliceVision
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://gforge.inria.fr/frs/?group_id=5833
## https://github.com/alicevision/geogram
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

PROG="geogram"
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/alicevision/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  # git clone --recurse-submodules -j8 $URL $PROG_DIR
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

cd $PROG_DIR
./configure.sh
cd build/Linux64-gcc-dynamic-Release ## For Release build
# cd build/Linux64-gcc-dynamic-Debug ## For Debug build
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------
