#!/bin/bash

##----------------------------------------------------------
## Caffee
## Tested on Ubuntu 16.04 LTS
#
## https://github.com/BVLC/caffe
#
## http://caffe.berkeleyvision.org/install_apt.html
## http://hanzratech.in/2015/07/27/installing-caffe-on-ubuntu.html
## https://gist.github.com/titipata/f0ef48ad2f0ebc07bcb9
#
##----------------------------------------------------------
#
## TBD:
## 1. CPU/GPU condition
## 2. OS version condition
#
##----------------------------------------------------------
## Compilation from Source: Git
##----------------------------------------------------------


# Installing Caffe from source dependencies
##----------------------------------------------------------

source ./linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS
DIR="caffe"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/BVLC/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

echo "Number of threads will be used: $NUMTHREADS"

echo "BASEPATH: $BASEPATH"
echo "URL: $URL"

## For Ubuntu (>= 17.04)
sudo apt build-dep caffe-cpu        # dependencies for CPU-only version
sudo apt build-dep caffe-cuda       # dependencies for CUDA version

## For Ubuntu (< 17.04)
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install --no-install-recommends libboost-all-dev
sudo apt-get install libopenblas-dev
##sudo apt-get install python-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev

sudo pip install numpy
sudo pip install scipy
sudo pip install protobuf
##sudo pip install skimage
sudo pip install scikit-image

# Required by dialation Model
sudo pip install numba

if [ ! -d $PROG_DIR ]; then
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
ccmake ..
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

##---------------

FILE=$HOME/.bashrc
LINE='export CAFFE_ROOT="$HOME/'$BASEDIR'/'$DIR'"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE='export PYTHONPATH="$CAFFE_ROOT/python"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

source $FILE
