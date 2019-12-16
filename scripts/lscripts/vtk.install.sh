#!/bin/bash

##----------------------------------------------------------
## VTK
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## The Visualization Toolkit (VTK) is an open-source, freely available software system for 3D computer graphics, image processing, and visualization. It consists of a C++ class library and several interpreted interface layers including Tcl/Tk, Java, and Python. VTK supports a wide variety of visualization algorithms including scalar, vector, tensor, texture, and volumetric methods, as well as advanced modeling techniques such as implicit modeling, polygon reduction, mesh smoothing, cutting, contouring, and Delaunay triangulation. 
#
## https://www.vtk.org/
## http://www.vtk.org/Wiki/VTK/Configure_and_Build
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
if [ -z "$VTK_RELEASE" ]; then
  VTK_VER="7.1"
  VTK_BUILD="1"
  VTK_RELEASE="$VTK_VER.$VTK_BUILD"

  VTK_VER="8.1"
  VTK_BUILD="0"
  VTK_RELEASE="$VTK_VER.$VTK_BUILD"
  echo "Unable to get VTK_RELEASE version, falling back to default version#: $VTK_RELEASE"
fi

source ./numthreads.sh ##NUMTHREADS
PROG='VTK'
DIR=$PROG-$VTK_RELEASE
PROG_DIR="$BASEPATH/$PROG-$VTK_RELEASE"
FILE="$DIR.tar.gz"

URL="http://www.vtk.org/files/release/$VTK_VER/$FILE"

echo "$FILE"
echo "URL: $URL"
echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "PROG_DIR: $PROG_DIR"

echo "Installing dependencies..."
sudo apt-get install libqt5x11extras5-dev
sudo apt-get install qttools5-dev

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c $URL -P $HOME/Downloads
else
  echo "Not downloading as: $HOME/Downloads/$FILE already exists!"
fi

if [ ! -d $BASEPATH/$DIR ]; then
  # tar xvfz $HOME/Downloads/$FILE -C $BASEPATH #verbose
  tar xfz $HOME/Downloads/$FILE -C $BASEPATH #silent mode
  echo "Extracting File: $HOME/Downloads/$FILE here: $BASEPATH/$DIR"
  echo "Extracting...DONE!"
else
  echo "Extracted Dir already exists: $BASEPATH/$DIR"
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi


mkdir -p $PROG_DIR/build
cd $PROG_DIR/build
# ./configure

cmake -D VTK_WRAP_PYTHON=ON \
      -D VTK_WRAP_JAVA=ON ..

## ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME

##----------------------------------------------------------
## Build for Android
##----------------------------------------------------------

# if [ -d $PROG_DIR/build-android ]; then
#   rm -rf $PROG_DIR/build-android
# fi

# mkdir -p $PROG_DIR/build-android
# cd $PROG_DIR/build-android
# # ./configure


# ## android paths
# ## https://stackoverflow.com/questions/10969753/android-command-not-found
# export ANDROID_HOME=$HOME/android/sdk
# export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# ## ANDROID_ARCH_ABI (Application Binary Interface, or ABI. )
# ## https://developer.android.com/ndk/guides/abis

# cmake -D VTK_WRAP_PYTHON=ON \
#       -D VTK_WRAP_JAVA=ON \
#       -D VTK_ANDROID_BUILD=ON \
#       -D ANDROID_NATIVE_API_LEVEL=26 \
#       -D ANDROID_ARCH_ABI=x86_64 \
#       -D ANDROID_NDK=$HOME/android/sdk/ndk-bundle ..

# cp -R $PROG_DIR/build/CMakeExternals/Install/vtk-android $BASEPATH/.


##----------------------------------------------------------
## Build Log
##----------------------------------------------------------

# ANDROID_NDK
# ANDROID_SDK

# CMake Warning at /usr/share/cmake-3.5/Modules/FindJava.cmake:158 (message):
#   regex not supported: openjdk version "9-internal"

#   OpenJDK Runtime Environment (build
#   9-internal+0-2016-04-14-195246.buildd.src)

#   OpenJDK 64-Bit Server VM (build 9-internal+0-2016-04-14-195246.buildd.src,
#   mixed mode).  Please report
# Call Stack (most recent call first):
#   CMake/vtkJavaWrapping.cmake:3 (find_package)
#   CMake/vtkWrapping.cmake:13 (include)
#   CMake/vtkModuleMacros.cmake:7 (include)
#   CMakeLists.txt:76 (include)


## Android
# CMake Error at CMake/vtkAndroid.cmake:1 (cmake_minimum_required):
#   CMake 3.7 or higher is required.  You are running version 3.5.1
# Call Stack (most recent call first):
#   CMakeLists.txt:149 (include)


# OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY", so for
#    compatibility with CMake 3.10 and below the legacy GL library will be used.


#  CMake Error at /usr/lib/x86_64-linux-gnu/cmake/Qt5/Qt5Config.cmake:26 (find_package):
#    Could not find a package configuration file provided by "Qt5X11Extras" with
#    any of the following names:

#      Qt5X11ExtrasConfig.cmake
#      qt5x11extras-config.cmake

#    Add the installation prefix of "Qt5X11Extras" to CMAKE_PREFIX_PATH or set
#    "Qt5X11Extras_DIR" to a directory containing one of the above files.  If
#    "Qt5X11Extras" provides a separate development package or SDK, be sure it
#    has been installed.
#  Call Stack (most recent call first):
#    GUISupport/Qt/CMakeLists.txt:72 (find_package)

# sudo apt-get install libqt5x11extras5-dev
# sudo apt-get install qttools5-dev

#  CMake Error at /usr/lib/x86_64-linux-gnu/cmake/Qt5/Qt5Config.cmake:26 (find_package):
#    Could not find a package configuration file provided by "Qt5UiPlugin" with
#    any of the following names:

#      Qt5UiPluginConfig.cmake
#      qt5uiplugin-config.cmake

#    Add the installation prefix of "Qt5UiPlugin" to CMAKE_PREFIX_PATH or set
#    "Qt5UiPlugin_DIR" to a directory containing one of the above files.  If
#    "Qt5UiPlugin" provides a separate development package or SDK, be sure it
#    has been installed.
#  Call Stack (most recent call first):
#    GUISupport/Qt/CMakeLists.txt:145 (find_package)

#  CMake Error at Web/Python/CMakeLists.txt:3 (message):
#    Web group can NOT work if VTK_WRAP_PYTHON is not ON.


#  CMake Warning (dev) at /usr/local/share/cmake-3.11/Modules/FindOpenGL.cmake:270 (message):
#    Policy CMP0072 is not set: FindOpenGL prefers GLVND by default when
#    available.  Run "cmake --help-policy CMP0072" for policy details.  Use the
#    cmake_policy command to set the policy and suppress this warning.

#    FindOpenGL found both a legacy GL library:

#      OPENGL_gl_LIBRARY: /usr/lib/x86_64-linux-gnu/libGL.so

#    and GLVND libraries for OpenGL and GLX:

#      OPENGL_opengl_LIBRARY: /usr/lib/x86_64-linux-gnu/libOpenGL.so
#      OPENGL_glx_LIBRARY: /usr/lib/x86_64-linux-gnu/libGLX.so

#    OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY", so for
#    compatibility with CMake 3.10 and below the legacy GL library will be used.
#  Call Stack (most recent call first):
#    CMake/vtkOpenGL.cmake:130 (find_package)
#    ThirdParty/glew/vtkglew/CMakeLists.txt:3 (include)
#  This warning is for project developers.  Use -Wno-dev to suppress it.


# GNUPLOT_EXECUTABLE
# OPENGL_xmesa_INCLUDE_DIR

# glew
# HDF5

#  CMake Error at /usr/local/share/cmake-3.11/Modules/FindPackageHandleStandardArgs.cmake:137 (message):
#    Could NOT find GDAL (missing: GDAL_LIBRARY GDAL_INCLUDE_DIR)
#  Call Stack (most recent call first):
#    /usr/local/share/cmake-3.11/Modules/FindPackageHandleStandardArgs.cmake:378 (_FPHSA_FAILURE_MESSAGE)
#    /usr/local/share/cmake-3.11/Modules/FindGDAL.cmake:88 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
#    IO/GDAL/CMakeLists.txt:1 (find_package)


# CMake Error at CMake/vtkWrapTcl.cmake:213 (MESSAGE):
#    Tk was not found.  Install the Tk development package (see http://tcl.tk or
#    ActiveState Tcl) and set the appropriate variables (TK_INCLUDE_PATH,
#    TK_LIBRARY, TK_WISH) or disable VTK_USE_TK.
#  Call Stack (most recent call first):
#    ThirdParty/TclTk/CMakeLists.txt:24 (include)



#  CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
#  Please set them or make sure they are set and tested correctly in the CMake files:
#  MYSQL_INCLUDE_DIRECTORIES (ADVANCED)
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#  MYSQL_LIBRARY (ADVANCED)
#      linked by target "vtkIOMySQL" in directory /home/thanos/softwares/VTK-8.1.0/IO/MySQL
#  ODBC_INCLUDE_DIRECTORIES (ADVANCED)
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#     used as include directory in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC
#  ODBC_LIBRARY (ADVANCED)
#      linked by target "vtkIOODBC" in directory /home/thanos/softwares/VTK-8.1.0/IO/ODBC

