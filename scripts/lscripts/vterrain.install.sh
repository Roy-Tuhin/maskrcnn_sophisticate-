#!/bin/bash

##----------------------------------------------------------
## vterrain
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
# http://vterrain.org/Download/
# https://github.com/kalwalt/ofxVTerrain
#
# ## Build Instructions:
# http://vterrain.org/Distrib/unix_build.html
#
# Library Version Typical Repository Name Library Website
# GDAL  2.0 or later  libgdal2-dev? http://www.gdal.org/
# PROJ.4  4.4.9 or later  (installed by GDAL) http://trac.osgeo.org/proj/
# OSG 3.0 or later  libopenscenegraph-dev http://www.openscenegraph.org/
# wxWidgets 3.0 or later  libwxgtk3.0-dev http://www.wxwidgets.org/
# libMini 8.9.2 or later  (none)  http://stereofx.org/terrain.html
# optional libraries:
# Libcurl (any) libcurl3  http://curl.haxx.se/
# Bzip2 (any) libbz2-dev   
# Squish  (any) (none)   
# QuikGrid  (any) (none)   

#
## https://wiki.tum.de/display/gisproject/OpenDrive
#
## http://vterrain.org/Distrib/unix.html
## http://vterrain.org/Doc/
## http://vterrain.org/Distrib/dir_struct_dev.html
#
## source code:
## http://vterrain.org/Distrib/hg.html
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


if [ -z "$VTERRAIN_VER" ]; then
  VTERRAIN_VER="2.2"
  echo "Unable to get VTERRAIN_VER version, falling back to default version#: $VTERRAIN_VER"
fi

## dependencies
sudo apt -y install openscenegraph libgdal-dev libjpeg-dev
sudo apt -y install bwxgtk3.0-dev libopenscenegraph-dev
sudo apt -y install libpng12-dev ## not present in Ubuntu-18.04 LTS

PROG='vtp'
DIR="$PROG-$VTERRAIN_VER"
PROG_DIR="$BASEPATH/$PROG-$VTERRAIN_VER"
FILE="vtp-src-130421.zip"
URL="http://vterrain.org/dist/$FILE"

echo "$FILE"
echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c $URL -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $BASEPATH/$DIR ]; then
  unzip -q $HOME/Downloads/$FILE -d $BASEPATH
else
  echo Extracted Dir already exists: $BASEPATH/$DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake ..
ccmake ..
make -j$NUMTHREADS
sudo make install  ## install into build dir

cd $LINUX_SCRIPT_HOME


## libMini

## download
# https://sourceforge.net/projects/libmini/
# http://stereofx.org/download/

mkdir build
cmake ..
ccmake ..
make
sudo make install

# vtp-src-130421/VTP/TerrainSDK/minidata/jpegbase.cpp:10:27: fatal error: mini/minibase.h: No such file or directory


# http://stereofx.org/terrain.html

# https://github.com/azzuriel/libmini/blob/master/libmini/Fraenkische/README


# https://sourceforge.net/projects/libmini/postdownload


# The Mini Library applies a view-dependent mesh simplification scheme to render large-scale terrain data at real-time. For this purpose, a quadtree representation of a height field is built. This quadtree is also utilized for fast view frustum culling and geomorphing.
# Within this distribution the files needed to build the basic terrain rendering library are included. In order to keep the library portable any system dependent stuff like window management is not part of this distribution. Nevertheless, the Mini Library implements all the necessary graphics algorithms to setup a high-performance terrain rendering system.

# The main goal for developing the library was to keep it as compact, stable and efficient as possible and not to blow it up by adding unnecessary features. Thus, Mini stands for "Mini Is Not Immense!" in a rather positive sense.


# The build.sh shell script compiles the library on Irix, Linux and MacOS X. Simply type "./build.sh" in your Unix shell (requires the tcsh to be installed). OpenGL is required as the single dependency of the library. To install the library and the necessary include files in /usr/local on your Unix machine type "./build.sh install" as a super-user.
# Optionally, you can use autoconf or CMake to build libMini. For the former, type "./configure && make" and for the latter type "cmake . && make" in a Unix shell.


# https://bitbucket.org/bdiscoe/vtp/src