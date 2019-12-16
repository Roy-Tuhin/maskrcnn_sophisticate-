#!/bin/bash

##----------------------------------------------------------
## cork
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## MPIR: Multiple Precision Integers and Rationals
## MPIR is a highly optimised library for bignum arithmetic forked from the GMP bignum library. It is written in assembly language and C.
#
## http://www.mpir.org/
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
if [ -z "$MPIR_REL_TAG" ]; then
  MPIR_REL_TAG="mpir-3.0.0"
  echo "Unable to get MPIR_REL_TAG version, falling back to default version#: $MPIR_REL_TAG"
fi

PROG='mpir'
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/wbhart/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  cd $PROG_DIR
  git checkout $MPIR_REL_TAG
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

cd $PROG_DIR
# currently compilation fails
./autogen.sh
./configure
make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

# /bin/sh: 1: clang++: not found
# Compiling obj/cork.o
# make: clang++: Command not found
# Makefile:206: recipe for target 'obj/cork.o' failed
# make: *** [obj/cork.o] Error 127

https://askubuntu.com/questions/584711/clang-and-clang-not-found-after-installing-the-clang-3-5-package

