#!/bin/bash

##----------------------------------------------------------
## libLAS
## Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://www.liblas.org
## https://github.com/libLAS/libLAS
#
##----------------------------------------------------------
## Change Log
##----------------------------------------------------------
## 2nd-Aug-2018
##---------------
## 1. Passed the required flags to cmake and hence ccmake is not required.
##    This is the step towards single script full-automation installation.
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

PROG='libLAS'
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/libLAS/$PROG.git"

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

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake -D WITH_GDAL=ON \
      -D WITH_GEOTIFF=ON \
      -D WITH_LASZIP=OFF \
      -D WITH_PKGCONFIG=ON \
      -D WITH_TESTS=ON \
      -D WITH_UTILITIES=ON \
      -D GDAL_DIR=$BASEPATH/gdal-$GDAL_VER \
      -D PROJ4_DIR=$BASEPATH/proj-$PROJ_VER \
      -D TIFF_DIR=$BASEPATH/tiff-$TIFF_VER ..
      # -D LASzip_DIR=$BASEPATH/LASzip \
    # -D ZLIB_DIR=$BASEPATH/zlib

# -D WITH_LASZIP=ON gives error
# provide the path to gdal, laszip, proj4j, tiff source directory
## ccmake ..
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME
