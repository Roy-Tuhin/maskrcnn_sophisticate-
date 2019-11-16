#!/bin/bash

##----------------------------------------------------------
## PROJ
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/fltk/fltk
## The Fast Light Tool Kit ("FLTK", pronounced "fulltick") is a a cross-platform C++ GUI toolkit for UNIX(r)/Linux(r) (X11), Microsoft(r) Windows(r), and MacOS(r) X. FLTK provides modern GUI functionality without the bloat and supports 3D graphics via OpenGL(r) and its built-in GLUT emulation. It was originally developed by Mr. Bill Spitzak and is currently maintained by a small group of developers across the world with a central repository in the US.
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

PROG="fltk"
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/fltk/$PROG.git"

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
cmake ..
ccmake ..
# make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS


# cd $PROG_DIR/IlmBase
# ./bootstrap
# ./configure
# make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS

# cd $PROG_DIR/OpenEXR
# ./bootstrap
# ./configure
# make -j$NUMTHREADS
# # sudo make install -j$NUMTHREADS

# cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------
