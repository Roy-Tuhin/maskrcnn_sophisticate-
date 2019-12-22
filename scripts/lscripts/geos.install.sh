#!/bin/bash

##----------------------------------------------------------
## GEOS
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
# GEOS is a spatial geometry library frequently used in GIS software and spatial databases.
# http://trac.osgeo.org/geos/
# http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#geos
# http://download.osgeo.org/geos/geos-3.6.1.tar.bz2
# http://download.osgeo.org/geos/geos-3.6.3.tar.bz2
# https://git.osgeo.org/gitea/geos/geos.git
#
##----------------------------------------------------------


function geos_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "$BASEPATH" ]; then
    BASEPATH="$HOME/softwares"
    echo "Unable to get BASEPATH, using default path#: $BASEPATH"
  fi

  if [ -z "$GEOS_VER" ]; then
    GEOS_VER="3.6.1"
    echo "Unable to get GEOS_VER version, falling back to default version#: $GEOS_VER"
  fi

  PROG='geos'
  DIR="$PROG-$GEOS_VER"
  PROG_DIR="$BASEPATH/$PROG-$GEOS_VER"
  FILE="$DIR.tar.bz2"

  echo "$FILE"
  echo "Number of threads will be used: $NUMTHREADS"
  echo "BASEPATH: $BASEPATH"
  echo "PROG_DIR: $PROG_DIR"

  if [ ! -f $HOME/Downloads/$FILE ]; then
    wget -c http://download.osgeo.org/geos/$FILE -P $HOME/Downloads
  else
    echo Not downloading as: $HOME/Downloads/$FILE already exists!
  fi

  if [ ! -d $BASEPATH/$DIR ]; then
    tar xvfj $HOME/Downloads/$FILE -C $BASEPATH
  else
    echo Extracted Dir already exists: $BASEPATH/$DIR
  fi

  # sudo apt-get install build-essential swig python-dev
  sudo -E apt-get install -y swig

  # http://osgeo-org.1560.x6.nabble.com/GEOS-753-cannot-build-geos-3-5-0-td5233885.html
  wget -c https://trac.osgeo.org/geos/export/HEAD/trunk/cmake/modules/GenerateSourceGroups.cmake -P $PROG_DIR/cmake/modules

  if [ -d $PROG_DIR/build ]; then
    rm -rf $PROG_DIR/build
  fi

  mkdir $PROG_DIR/build
  cd $PROG_DIR/build
  cmake ..

  ## not required
  # ccmake ..

  make -j$NUMTHREADS
  sudo make install -j$NUMTHREADS

  cd ${LSCRIPTS}
}

geos_install
