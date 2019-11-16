#!/bin/bash

##----------------------------------------------------------
## laz-perf
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/hobu/laz-perf
## Alternative LAZ implementation. It supports compilation and usage in JavaScript, usage in database contexts such as pgpointcloud and Oracle Point Cloud, and it executes faster than the LASzip codebase.
## https://github.com/pgpointcloud/pointcloud
##-- Could NOT find LazPerf (missing: LAZPERF_INCLUDE_DIR) 
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
if [ -z "$LAZ_PERF_REL_TAG" ]; then
  LAZ_PERF_REL_TAG="1.3.0"
  echo "Unable to get LAZ_PERF_REL_TAG version, falling back to default version#: $LAZ_PERF_REL_TAG"
fi

DIR="laz-perf"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/hobu/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  cd $PROG_DIR
  git checkout $LAZ_PERF_REL_TAG
else
  echo Gid clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake ..

# ### not required
# ## ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME
