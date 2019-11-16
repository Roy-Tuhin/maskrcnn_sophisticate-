#!/bin/bash

##----------------------------------------------------------
## Boost Python
## Tested on Ubuntu 16.04
#
# http://boostorg.github.io/python
##----------------------------------------------------------

source ./numthreads.sh ##NUMTHREADS

PROG='boost'

VER="1.64.0"
DIR="boost_1_64_0"

## OpenGV does not compiles with 1.67.0 which is the prerequiste for OpenSfM: 
# VER="1.67.0"
# DIR="boost_1_67_0"

FILE="$DIR.tar.gz"
BASEPATH="$HOME/softwares"

URL="https://dl.bintray.com/boostorg/release/$VER/source/$FILE"

echo "$URL"
echo "Number of threads will be used: $NUMTHREADS"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget $URL  -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $BASEPATH/$DIR ]; then
  tar xvfz $HOME/Downloads/$FILE -C $BASEPATH
else
  echo Extracted Dir already exists: $BASEPATH/$DIR
fi

cd $BASEPATH/$DIR

sudo ./bootstrap.sh --prefix=/usr/local --with-libraries=all
#sudo ./b2 install
#sudo ./b2 install -j 8
sudo ./b2 install -j$NUMTHREADS


## OpenSfM Dependencies
# # export
# # BOOST_ROOT="$HOME/softwares/$DIR"
# Boost_LIBRARYDIR="/usr/local/lib"
# BOOST_INCLUDEDIR="/usr/local/include"

# # not sure which worked
# # this is required for OpenSfM to compile

# #sudo ln -s libboost_python35.so.1.67.0 libboost_python.so
# #sudo ln -s libboost_numpy35.so.1.67.0 libboost_numpy.so
# sudo ln -s libboost_python35.so.$VER libboost_python.so
# sudo ln -s libboost_numpy35.so.$VER libboost_numpy.so

# sudo apt-get install libboost-python-dev