#!/bin/bash

##----------------------------------------------------------
## laszip
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/LASzip/LASzip/
## https://www.laszip.org/
#
## CMake Error at cmake/modules/FindLASzip.cmake:66 (FILE):
##   FILE failed to open for reading (No such file or directory):
#
##     /usr/local/include/laszip/laszip.hpp
## Call Stack (most recent call first):
##   CMakeLists.txt:218 (find_package)
#
## CMake Error at cmake/modules/FindLASzip.cmake:94 (MESSAGE):
##   Failed to open /usr/local/include/laszip/laszip.hpp file
## Call Stack (most recent call first):
##   CMakeLists.txt:218 (find_package)
#
## sudo cp src/laszip.hpp /usr/local/include/laszip/.
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

DIR="LASzip"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/LASzip/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

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
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

## Required for libLAS compilation: WITH_LASZIP=ON
## This sill gives error for libLAS compilation: TBD
# sudo cp src/laszip.hpp /usr/local/include/laszip/.

cd $LINUX_SCRIPT_HOME
