#!/bin/bash

##----------------------------------------------------------
## libkml
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## libkml is a KML library. It is used by GDAL and other GIS software to read/write KML files
#
## https://code.google.com/archive/p/libkml
## http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#libkml
## https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkml/libkml-1.2.0.tar.gz
## https://github.com/libkml/libkml/blob/wiki/BuildingAndInstalling.md
## Compiling 1.2.0 gives error on Ubuntu 16.04
## https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=667247
#
##----------------------------------------------------------
## Issues and Fixes
##----------------------------------------------------------
## LIBKML_VER 1.3.0 has build Issues
## https://github.com/libkml/libkml/issues/253
#
## minizip libminizip-dev installation fixed the minizip error while building with git clone.
##----------------------------------------------------------
## Error: curl-config script could not be found
##-----------
## https://gist.github.com/lxneng/1031014
#
## configure: WARNING: You have SWIG 3.0.8 installed, but libkml requires at least SWIG 1.3.35. The bindings will not be built.
## checking for curl-config... no
## *** The curl-config script could not be found. Make sure it is
## *** in your path, and that curl is properly installed.
## *** Or see http://curl.haxx.se/
# configure: error: Library requirements (curl) not met.
##----------------------------------------------------------
## Warining: swig version
##-----------
## configure: WARNING: You have SWIG 3.0.8 installed, but libkml requires at least SWIG 1.3.35. The bindings will not be built.
#
##----------------------------------------------------------
#
##----------------------------------------------------------
## Change Log
##----------------------------------------------------------
## 2nd-Aug-2018
##---------------
## 1. Passed the required flags to cmake and hence ccmake is not required.
##    This is the step towards single script full-automation installation.
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

if [ -z "$LIBKML_VER" ]; then
  # LIBKML_VER="1.2.0"
  LIBKML_VER="1.3.0"
  echo "Unable to get LIBKML_VER version, falling back to default version#: $LIBKML_VER"
fi

sudo -E apt -q -y install swig
sudo -E apt -q -y install libcurl4-gnutls-dev librtmp-dev
# This solved minizip error with git clone
sudo -E apt -q -y install minizip libminizip-dev

PROG='libkml'
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/libkml/$PROG.git"
# URL="https://github.com/libkml/libkml/tree/synced_upstream"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake -D WITH_JAVA=ON \
      -D WITH_PYTHON=ON \
      -D WITH_SWIG=OFF ..

# ccmake ..
# WITH_JAVA                        ON                                                                                                                  
# WITH_PYTHON                      ON                                                                                                                  
# WITH_SWIG                        OFF 

#make distclean
make -j$NUMTHREADS
sudo make install -j$NUMTHREADS  ## install into build dir

cd $LINUX_SCRIPT_HOME

##----------------------------------------------------------
## TBD: option to clone or install from zip/tar file
##----------------------------------------------------------

# DIR="$PROG-$LIBKML_VER"
# PROG_DIR="$BASEPATH/$PROG-$LIBKML_VER"
# FILE="$PROG-$LIBKML_VER.tar.gz"

# echo "$FILE"
# echo "PROG_DIR: $PROG_DIR"

# if [ ! -f $HOME/Downloads/$FILE ]; then
#  wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkml/$FILE -P $HOME/Downloads
# else
#  echo Not downloading as: $HOME/Downloads/$FILE already exists!
# fi

# if [ ! -d $BASEPATH/$DIR ]; then
#   tar xvfz $HOME/Downloads/$FILE -C $BASEPATH
# else
#   echo Extracted Dir already exists: $BASEPATH/$DIR
# fi

# cd $PROG_DIR
# ./configure
# cmake ../libkml-$LIBKML_VER
# make -j$NUMTHREADS
# sudo make install  ## install into build dir
# cd $LINUX_SCRIPT_HOME
##----------------------------------------------------------


##----------------------------------------------------------
## Error: build errors
## ver 1.3.0
##-----------


# -D WITH_SWIG=ON gave error
# CMake Error at src/swig/cmake_install.cmake:77 (file):
#   file INSTALL cannot find
#   "libkml/build/src/swig/kmlbase.pyc"

##-----------
## ver 1.2.0
##-----------

# https://code.google.com/archive/p/libkml/issues/179
# https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=667247;filename=libkml.debdiff;msg=10
# https://github.com/google/libkml/blob/master/src/kml/base/file_posix.cc

# file_posix.cc:56:10: error: ‘unlink’ was not declared in this scope
#    return unlink(filepath.c_str()) == 0;
#           ^~~~~~
# file_posix.cc:56:10: note: suggested alternative: ‘ulong’
#    return unlink(filepath.c_str()) == 0;
#           ^~~~~~
#           ulong
# file_posix.cc: In static member function ‘static bool kmlbase::File::CreateNewTempFile(std::__cxx11::string*)’:
# file_posix.cc:68:3: error: ‘close’ was not declared in this scope
#    close(fd);
#    ^~~~~
# file_posix.cc:68:3: note: suggested alternative: ‘clone’
#    close(fd);
#    ^~~~~
#    clone
# Makefile:821: recipe for target 'file_posix.lo' failed
# make[4]: *** [file_posix.lo] Error 1
# make[4]: *** Waiting for unfinished jobs....



##----------------------------------------------------------
## Error: build errors
## git clone
##-----------

# https://github.com/libkml/libkml/issues/253
# https://github.com/rogersce/cnpy/issues/13

# [ 88%] Linking C executable minizipz
# CMakeFiles/minizipz.dir/minizip.c.o: In function `get_file_crc':
# minizip.c:(.text+0x2a2): undefined reference to `crc32'
# minizip.c:(.text+0x2c5): undefined reference to `crc32'
# libminizip.so.1.2.8: undefined reference to `get_crc_table'
# libminizip.so.1.2.8: undefined reference to `inflate'
# libminizip.so.1.2.8: undefined reference to `deflate'
# libminizip.so.1.2.8: undefined reference to `deflateInit2_'
# libminizip.so.1.2.8: undefined reference to `inflateEnd'
# libminizip.so.1.2.8: undefined reference to `deflateEnd'
# libminizip.so.1.2.8: undefined reference to `inflateInit2_'
# collect2: error: ld returned 1 exit status
# CMakeFiles/minizipz.dir/build.make:95: recipe for target 'minizipz' failed
# make[5]: *** [minizipz] Error 1
# CMakeFiles/Makefile2:67: recipe for target 'CMakeFiles/minizipz.dir/all' failed
# make[4]: *** [CMakeFiles/minizipz.dir/all] Error 2
# Makefile:140: recipe for target 'all' failed
# make[3]: *** [all] Error 2
# CMakeFiles/MiniZip.dir/build.make:57: recipe for target 'CMakeFiles/MiniZip' failed
# make[2]: *** [CMakeFiles/MiniZip] Error 2
# CMakeFiles/Makefile2:99: recipe for target 'CMakeFiles/MiniZip.dir/all' failed
# make[1]: *** [CMakeFiles/MiniZip.dir/all] Error 2
# Makefile:129: recipe for target 'all' failed
# make: *** [all] Error 2


