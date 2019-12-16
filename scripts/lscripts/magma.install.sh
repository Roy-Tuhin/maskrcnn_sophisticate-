#!/bin/bash
##----------------------------------------------------------
# Magma
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://icl.utk.edu/magma/software/index.html
#
## MAGMA provides implementations for CUDA, Intel Xeon Phi, and OpenCL. The latest releases are MAGMA 2.5, MAGMA MIC 1.4.0, and clMAGMA 1.3, respectively. The libraries available for download are listed below in the order of their release dates.
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
if [ -z "$MAGMA_VER" ]; then
  MAGMA_VER="2.5.0-rc1"
  echo "Unable to get MAGMA_VER version, falling back to default version#: $MAGMA_VER"
fi

PROG='magma'
DIR="$PROG-$MAGMA_VER"
PROG_DIR="$BASEPATH/$PROG-$MAGMA_VER"
FILE="$DIR.tar.gz"

URL="http://icl.utk.edu/projectsfiles/magma/downloads/$FILE"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c $URL -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $HOME/softwares/$DIR ]; then
  tar xvfz $HOME/Downloads/$FILE -C $HOME/softwares
else
  echo Extracted Dir already exists: $HOME/softwares/$DIR
fi


if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------
