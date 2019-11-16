#!/bin/bash

##----------------------------------------------------------
## caffe2
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://caffe2.ai/
## https://caffe2.ai/docs/getting-started.html?platform=ubuntu&configuration=prebuilt
## https://opensource.fb.com/
## https://github.com/caffe2/caffe2/issues/274
## https://caffe2.ai/docs/caffe-migration.html#how-is-caffe2-different-from-pytorch
#
##----------------------------------------------------------

# sudo pip install future numpy protobuf

source ./numthreads.sh ##NUMTHREADS

BASEPATH="$HOME/softwares"
DIR="pytorch"

URL="https://github.com/pytorch/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"

echo "BASEPATH: $BASEPATH"
echo "URL: $URL"

git -C $BASEPATH/$DIR || git clone $URL $BASEPATH/$DIR

git clone --recursive $URL
cd $BASEPATH/$DIR
git submodule update --init

if [ -d $BASEPATH/$DIR/build ]; then
  rm -rf $BASEPATH/$DIR/build
fi

mkdir $BASEPATH/$DIR/build
cd $BASEPATH/$DIR/build
cmake ..
ccmake ..
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

## Test the Caffe2 Installation

cd ~ && python -c 'from caffe2.python import core' 2>/dev/null && echo "Success" || echo "Failure"
