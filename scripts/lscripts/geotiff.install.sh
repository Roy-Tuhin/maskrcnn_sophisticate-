#!/bin/bash

##----------------------------------------------------------
## GeoTIFF
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## GeoTIFF is a library for geospatial TIFF images. It is used by most raster-enabled GIS software.
## GeoTIFF builds on proj and libtiff, so these should be installed first
#
## http://trac.osgeo.org/geotiff
## http://download.osgeo.org/geotiff/libgeotiff/
## http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.2.tar.gz
## http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#geotiff
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

source $LSCRIPTS/lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

if [ -z "$GEOTIFF_VER" ]; then
  GEOTIFF_VER="1.4.2"
  echo "Unable to get GEOTIFF_VER version, falling back to default version#: $GEOTIFF_VER"
fi

PROG='libgeotiff'
DIR="$PROG-$GEOTIFF_VER"
PROG_DIR="$BASEPATH/$PROG-$GEOTIFF_VER"
FILE="$DIR.tar.gz"

echo "$FILE"
echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget http://download.osgeo.org/geotiff/libgeotiff/$FILE -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $BASEPATH/$DIR ]; then
  tar xvfz $HOME/Downloads/$FILE -C $BASEPATH
else
  echo Extracted Dir already exists: $BASEPATH/$DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake -D WITH_JPEG=ON \
      -D WITH_PROJ4=ON \
      -D WITH_TIFF=ON \
      -D WITH_TOWGS84=ON \
      -D WITH_UTILITIES=ON \
      -D WITH_ZLIB=ON \
      -D TIFF_DIR=$BASEPATH/tiff-$TIFF_VER \
      -D PROJ4_DIR=$BASEPATH/proj-$PROJ_VER  ..

# ccmake ..

# WITH_JPEG                        ON                              
# WITH_PROJ4                       ON                              
# WITH_TIFF                        ON                              
# WITH_TOWGS84                     ON                              
# WITH_UTILITIES                   ON                              
# WITH_ZLIB                        ON

## enabled all the options
make -j$NUMTHREADS
sudo make install  ## install into build dir

cd $LINUX_SCRIPT_HOME
