#!/bin/bash
##----------------------------------------------------------
# AliceVision
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/alicevision/meshroom
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

sudo apt -y install libpng-dev libjpeg-dev libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev

PROG="meshroom"
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/alicevision/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  git clone --recurse-submodules -j8 $URL $PROG_DIR
  # git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

cd $PROG_DIR

pip install -r requirements.txt

# cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

# -- Found OpenEXR: /usr/include (found version "2.2.0") 
# CMake Warning at src/cmake/FindOpenEXR.cmake:164 (message):
#   ILMBASE_INCLUDE_DIR: /usr/include;/usr/include/OpenEXR
# Call Stack (most recent call first):
#   src/CMakeLists.txt:269 (find_package)


# -- OpenEXR found. (Version 2.2.0)
# CMake Warning at src/cmake/FindOpenEXR.cmake:164 (message):
#   ILMBASE_INCLUDE_DIR: /usr/include;/usr/include/OpenEXR
# Call Stack (most recent call first):
#   src/cmake/FindOpenImageIO.cmake:1 (find_package)
#   src/CMakeLists.txt:279 (find_package)


# CMake Error at src/cmake/FindOpenImageIO.cmake:28 (message):
#   Failed to find OpenImageIO - Could not find OpenImageIO include directory,
#   set OPENIMAGEIO_INCLUDE_DIR to directory containing OpenImageIO/imageio.h
# Call Stack (most recent call first):
#   src/cmake/FindOpenImageIO.cmake:90 (openimageio_report_not_found)
#   src/CMakeLists.txt:279 (find_package)


# -- Configuring incomplete, errors occurred!
# See also "/home/bhaskar/softwares/AliceVision/build/CMakeFiles/CMakeOutput.log".
