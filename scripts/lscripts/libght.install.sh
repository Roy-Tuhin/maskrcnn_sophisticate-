#!/bin/bash
##----------------------------------------------------------
## libght
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## GeoHashTree for Point Cloud Data
## https://github.com/pramsey/libght/
#
## https://github.com/pgpointcloud/pointcloud
##-- Could NOT find CUnit (missing: CUNIT_LIBRARY CUNIT_INCLUDE_DIR) 
##-- Could NOT find LibGHT (missing: LIBGHT_LIBRARY LIBGHT_INCLUDE_DIR) 
##-- Could NOT find LazPerf (missing: LAZPERF_INCLUDE_DIR) 
#
## CUnit - Automation test suite for C
## https://mysnippets443.wordpress.com/2015/03/07/ubuntu-install-cunit/
##----------------------------------------------------------
#
## CMake Error at /usr/share/cmake-3.10/Modules/FindPackageHandleStandardArgs.cmake:137 (message):
##   Could NOT find LibXml2 (missing: LIBXML2_LIBRARY LIBXML2_INCLUDE_DIR)
## Call Stack (most recent call first):
##   /usr/share/cmake-3.10/Modules/FindPackageHandleStandardArgs.cmake:378 (_FPHSA_FAILURE_MESSAGE)
##   /usr/share/cmake-3.10/Modules/FindLibXml2.cmake:85 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
##   CMakeLists.txt:87 (find_package)
##
##  CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
##  Please set them or make sure they are set and tested correctly in the CMake files:
##  CUNIT_INCLUDE_DIR
##     used as include directory in directory /home/game1/softwares/libght/test
#
##  LIBLAS_INCLUDE_DIR               LIBLAS_INCLUDE_DIR-NOTFOUND                                                                                         
##  LIBLAS_LIBRARY                   LIBLAS_LIBRARY-NOTFOUND 
##----------------------------------------------------------

## sudo apt-get install libcunit1 libcunit1-doc libcunit1-dev
## sudo apt install libcunit1 libcunit1-dev

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

sudo apt install -y libxml2-dev
# sudo apt install -y liblas-dev # some issue with libght
sudo apt install -y libcunit1 libcunit1-dev

## Un-comment or install separately
## If followed the given sequence, this would already be installed

# source $LINUX_SCRIPT_HOME/laz-perf.install.sh

DIR="libght"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/pramsey/$DIR.git"

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
cmake ..

### Not required
## ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME
