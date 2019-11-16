#!/bin/bash

##----------------------------------------------------------
## cork
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Cork Boolean/CSG library. Cork is designed to support Boolean operations between triangle meshes.
#
## https://github.com/cloudcompare/cork
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

PROG='cork'
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/cloudcompare/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

cd $PROG_DIR
# currently compilation fails
make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME
