#!/bin/bash

##----------------------------------------------------------
## laszip
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## References:
## http://www.laszip.org/
## https://github.com/LASzip/LASzip/releases/download/v2.2.0/laszip-src-2.2.0.tar.gz
#
##----------------------------------------------------------

source ./lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

if [ -z "$LASZIP_VER" ]; then
  LASZIP_VER="2.2.0"
  LASZIP_VER="3.2.2"
  echo "Unable to get LASZIP_VER version, falling back to default version#: $LASZIP_VER"
fi
source ./numthreads.sh ##NUMTHREADS


PROG='laszip-src'
DIR="$PROG-$LASZIP_VER"
PROG_DIR="$BASEPATH/$DIR"
FILE="$DIR.tar.gz"

# URL="https://github.com/LASzip/LASzip/releases/download/v$LASZIP_VER/$FILE"
URL="https://github.com/LASzip/LASzip/releases/download/$LASZIP_VER/$FILE"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "$FILE"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  #wget $URL -P $HOME/Downloads
  wget $URL -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

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
sudo make install
