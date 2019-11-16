#!/bin/bash

##----------------------------------------------------------
## protobuf
## https://github.com/google/protobuf
## https://github.com/google/protobuf/blob/master/src/README.md
#
# make[2]: Entering directory '/home/thanos/softwares/protobuf/src'
# make[3]: Entering directory '/home/thanos/softwares/protobuf/src'
# PASS: google/protobuf/io/gzip_stream_unittest.sh
# PASS: google/protobuf/compiler/zip_output_unittest.sh
# PASS: protobuf-lite-arena-test
# PASS: protobuf-lite-test
# PASS: no-warning-test
# PASS: protobuf-lazy-descriptor-test
# PASS: protobuf-test
# ============================================================================
# Testsuite summary for Protocol Buffers 3.5.2
# ============================================================================
# # TOTAL: 7
# # PASS:  7
# # SKIP:  0
# # XFAIL: 0
# # FAIL:  0
# # XPASS: 0
# # ERROR: 0
# ============================================================================
# make[3]: Leaving directory '/home/thanos/softwares/protobuf/src'
# make[2]: Leaving directory '/home/thanos/softwares/protobuf/src'
# make[1]: Leaving directory '/home/thanos/softwares/protobuf/src'
#
# Libraries have been installed in:
#    /usr/local/lib

# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the '-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the 'LD_RUN_PATH' environment variable
#      during linking
#    - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to '/etc/ld.so.conf'

# See any operating system documentation about shared libraries for
# more information, such as the ld(1) and ld.so(8) manual pages.
# ----------------------------------------------------------------------
#  /bin/mkdir -p '/usr/local/bin'
#   /bin/bash ../libtool   --mode=install /usr/bin/install -c protoc '/usr/local/bin'
# libtool: install: /usr/bin/install -c .libs/protoc /usr/local/bin/protoc
# make[2]: Leaving directory '/home/thanos/softwares/protobuf/src'
# make[1]: Leaving directory '/home/thanos/softwares/protobuf/src'

##----------------------------------------------------------


#-------------------------
## Setup Prerequisites
#-------------------------
#sudo apt-get install autoconf automake libtool curl make g++ unzip
#-------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

DIR="protobuf"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/google/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

cd $PROG_DIR
git submodule update --init --recursive
echo "Executing: ./autogen.sh"
./autogen.sh
echo "Executing: ./configure"
./configure

make -j$NUMTHREADS
make check -j$NUMTHREADS
sudo make install -j$NUMTHREADS
sudo ldconfig # refresh shared library cache

cd $LINUX_SCRIPT_HOME

