#!/bin/bash

##----------------------------------------------------------
## tiff
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
# A library for TIFF images, used by geotiff, gdal, and most raster-capable GIS software
#
# http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
# http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#libtiff
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

if [ -z "$TIFF_VER" ]; then
  TIFF_VER="4.0.8"
  echo "Unable to get TIFF_VER version, falling back to default version#: $TIFF_VER"
fi

PROG='tiff'
DIR="$PROG-$TIFF_VER"
PROG_DIR="$BASEPATH/$PROG-$TIFF_VER"
FILE="$DIR.tar.gz"

echo "$FILE"
echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c http://download.osgeo.org/libtiff/$FILE -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $BASEPATH/$DIR ]; then
  tar xvfz $HOME/Downloads/$PROG-$TIFF_VER.tar.gz -C $BASEPATH
else
  echo Extracted Dir already exists: $BASEPATH/$DIR
fi

# nb: build dir already exists

cd $PROG_DIR
make clean -j$NUMTHREADS
./configure
make -j$NUMTHREADS
sudo make install  ## install into build dir

cd $LINUX_SCRIPT_HOME
