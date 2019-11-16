#!/bin/bash

##----------------------------------------------------------
## OpenSceneGraph - OSG
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## The OpenSceneGraph is an open source high performance 3D graphics toolkit, used by application developers in fields such as visual simulation, games, virtual reality, scientific visualization and modelling. Written entirely in Standard C++ and OpenGL
#
## https://github.com/openscenegraph/OpenSceneGraph
## http://www.openscenegraph.org/index.php/documentation
#
## The build system is configured to install libraries to /usr/local/lib64
## Your applications may not be able to find your installed libraries unless you:
##     set your LD_LIBRARY_PATH (user specific) or
##     update your ld.so configuration (system wide)
## You have an ld.so.conf.d directory on your system, so if you wish to ensure that
## applications find the installed osg libraries, system wide, you could install an
## OpenSceneGraph specific ld.so configuration with:
##     sudo make install_ld_conf
#
##----------------------------------------------------------

source ./linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS
PROG='OpenSceneGraph'
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/openscenegraph/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake ..

##note required
# ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

# [ 82%] Building CXX object src/osgPlugins/ive/CMakeFiles/osgdb_ive.dir/Effect.cpp.o
# Assembler messages:
# Fatal error: can't create CMakeFiles/osgdb_ive.dir/DrawElementsUShort.cpp.o: No such file or directory
# src/osgPlugins/ive/CMakeFiles/osgdb_ive.dir/build.make:926: recipe for target 'src/osgPlugins/ive/CMakeFiles/osgdb_ive.dir/DrawElementsUShort.cpp.o' failed
# make[2]: *** [src/osgPlugins/ive/CMakeFiles/osgdb_ive.dir/DrawElementsUShort.cpp.o] Error 1
# make[2]: *** Waiting for unfinished jobs....
# make[2]: *** No rule to make target '../src/osgWrappers/serializers/osgSim/LibraryWrapper.cpp', needed by 'src/osgWrappers/serializers/osgSim/CMakeFiles/osgdb_serializers_osgsim.dir/LibraryWrapper.cpp.o'.  Stop.
# make[2]: *** Waiting for unfinished jobs....
# sh: 0: getcwd() failed: No such file or directory
# Building CXX object src/osgWrappers/serializers/osgSim/CMakeFiles/osgdb_serializers_osgsim.dir/Impostor.cpp.o
