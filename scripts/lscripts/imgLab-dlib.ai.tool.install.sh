#!/bin/bash
##----------------------------------------------------------
## dlib imgLab
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/davisking/dlib.git
#
##----------------------------------------------------------

source ./lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS
DIR="dlib"
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

IMGLAB_DIR="$BASEPATH/$DIR/tools/imglab"
if [ -d $IMGLAB_DIR/build ]; then
  rm -rf $IMGLAB_DIR/build
fi

mkdir $IMGLAB_DIR/build
cd $IMGLAB_DIR/build
# cmake ..
## If compiling with CUDA support on Ubuntu 18.04 gcc-7 is not yet supported and hence gcc-6 has to be installed at prior
## provides the compiler flag at the cmake
cmake -DCMAKE_C_COMPILER=/usr/bin/gcc-6 -DCMAKE_CXX_COMPILER=/usr/bin/g++-6 ..


### Not required
## ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME
