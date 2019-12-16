#!/bin/bash
##----------------------------------------------------------
# popsift
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/alicevision/popsift
## PopSift is an implementation of the SIFT algorithm in CUDA. PopSift tries to stick as closely as possible to David Lowe's famous paper (Lowe, D. G. (2004). Distinctive Image Features from Scale-Invariant Keypoints. International Journal of Computer Vision, 60(2), 91–110. doi:10.1023/B:VISI.0000029664.99615.94), while extracting features from an image in real-time at least on an NVidia GTX 980 Ti GPU.
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


PROG="popsift"
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

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake ..
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------
