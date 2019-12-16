#!/bin/bash

##----------------------------------------------------------
## Eigen
## Tested on Ubuntu 16.04 LTS, 18.04 LTS
##----------------------------------------------------------
#
## Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms.
#
## http://eigen.tuxfamily.org/index.php?title=Main_Page
## https://github.com/eigenteam/eigen-git-mirror
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
if [ -z "$EIGEN_REL_TAG" ]; then
  EIGEN_REL_TAG="3.3.5"
  echo "Unable to get EIGEN_REL_TAG version, falling back to default version#: $EIGEN_REL_TAG"
fi

PROG='eigen'
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/eigenteam/$DIR-git-mirror.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  cd $PROG_DIR
  git checkout $EIGEN_REL_TAG
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

## Note: not installing eigen to /usr/local as it may risk corrupting other dependend programs, infact most of them
# sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME

