#!/bin/bash

# http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html#installation-instructions
# https://github.com/kripken/emscripten

source ./numthreads.sh ##NUMTHREADS

BASEPATH="$HOME/softwares"
DIR="emsdk"
#DOWNLOAD=$HOME/Downloads

URL="https://github.com/juj/$DIR.git"

#git clone $URL $BASEPATH/$DIR

mkdir $BASEPATH/$DIR/build

cd $BASEPATH/$DIR/build
./emsdk install latest

# cmake ..
# make -j$NUMTHREADS
# sudo make install