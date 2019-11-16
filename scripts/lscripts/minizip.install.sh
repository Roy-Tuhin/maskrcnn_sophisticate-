#!/bin/bash

# libkml
# libkml is a KML library. It is used by GDAL and other GIS software to read/write KML files

# References:
# https://code.google.com/archive/p/libkml
# http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#libkml
# https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkml/libkml-1.2.0.tar.gz
# https://github.com/libkml/libkml/blob/wiki/BuildingAndInstalling.md
# Compiling 1.2.0 gives error on Ubuntu 16.04
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=667247

source ./numthreads.sh ##NUMTHREADS
PROG='minizip'
DIR="$PROG"
echo "$DIR"
threads=$NUMTHREADS
echo "Number of threads will be used: $NUMTHREADS"

git -C $HOME/softwares/$DIR || git clone https://github.com/nmoinvaz/$PROG $HOME/softwares/$DIR

PROG_DIR="$HOME/softwares/$DIR"
cd $PROG_DIR
echo $(pwd)
cmake .
cmake --build .
make
sudo make install
