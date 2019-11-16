#!/bin/bash

##----------------------------------------------------------
## PROJ
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/OpenImageIO/oiio
## OpenImageIO is an open source library for reading and writing images. Support for different image formats is realised through plugins
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

sudo apt -y install python-openimageio openimageio-tools libopenimageio1.7 libopenimageio-doc libopenimageio-dev ## alternative to Build

PROG="oiio"
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/OpenImageIO/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  ## git clone --recurse-submodules -j8 $URL $PROG_DIR
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  # git checkout v2.3.0
else
  echo Git clone for $URL exists at: $PROG_DIR
fi


mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake -DBUILD_DOCS=OFF \
      -DBUILD_TESTING=OFF \
      -DINSTALL_DOCS=OFF \
      -DOIIO_BUILD_TESTS=OFF \
      -DOIIO_BUILD_TOOLS=OFF \
      -DSTOP_ON_WARNING=OFF \
      -DUSE_DICOM=OFF \
      -DUSE_CPP=11 \
      -DUSE_LIBRAW=OFF \
      -DUSE_NUKE=OFF \
      -DUSE_OCIO=OFF \
      -DBUILD_MISSING_DEPS=ON \
      -DBUILDSTATIC=ON \
      -DBUILD_OIIOUTIL_ONLY=ON \
      -DPYLIB_INCLUDE_SONAME=ON \
      -DUSE_fPIC=ON \
      -DBUILDSTATIC=OFF \
      -DUSE_PYTHON=ON ..



ccmake ..
make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS


# cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

## https://github.com/OpenImageIO/oiio/issues/1589

# [ 78%] Linking CXX executable filter_test
# libOpenImageIO.so.2.0.1: undefined reference to `Imf_2_3::Header::type[abi:cxx11]() const'
# libOpenImageIO.so.2.0.1: undefined reference to `typeinfo for Iex_2_3::BaseExc'
# libOpenImageIO.so.2.0.1: undefined reference to `Imf_2_3::FrameBuffer::insert(char const*, Imf_2_3::

# https://stackoverflow.com/questions/10851247/how-to-activate-c-11-in-cmake

# find . -iname "*" -type f -exec grep -inH --color="auto" "OPENEXR_HOME" {} \;
# ./Makefile:191:ifneq (${OPENEXR_HOME},)
# ./Makefile:192:MY_CMAKE_FLAGS += -DOPENEXR_ROOT_DIR:STRING=${OPENEXR_HOME}
# 23:08:22:oiio$pwd

