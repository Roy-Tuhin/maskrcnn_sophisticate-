#!/bin/bash
##----------------------------------------------------------
# CloudCompare
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://www.cloudcompare.org/
## https://github.com/CloudCompare/CloudCompare.git
## https://bintray.com/package/readme/ornis/CloudCompare/CloudCompare
#
##----------------------------------------------------------
## Compiling from source:
## https://github.com/CloudCompare/CloudCompare/blob/master/BUILD.md
## https://www.cloudcompare.org/doc/wiki/index.php?title=Compilation
##----------------------------------------------------------
#
## 1. INSTALL_QCOMPASS_PLUGIN and INSTALL_QHOUGH_NORMALS_PLUGIN needs eigen compilation from source
##   -D EIGEN_ROOT_DIR=$HOME/softwares/eigen/build \
##   -D INSTALL_QCOMPASS_PLUGIN=ON \
##   -D INSTALL_QHOUGH_NORMALS_PLUGIN=ON \
#
## 2. OPTION_USE_LIBE57FORMAT LIBE57FORMAT compilation from source
## -D LIBE57FORMAT_INSTALL_DIR=/usr/local/E57Format-2.0-x86_64-linux-gcc55 \
## -D OPTION_USE_LIBE57FORMAT=ON \
#
## 3. INSTALL_QCORK_PLUGIN needs cork and mpir compilation from source
#
##----------------------------------------------------------
#
## snap package
## snap install cloudcompare
#
## https://fas.org/man/dod-101/navy/docs/fun/index.html
## https://www.danielgm.net/cc/doc/CCLib/html/index.html
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh


# sudo add-apt-repository --remove ppa:romain-janvier/cloudcompare
# sudo -E apt remove cloudcompare
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
# #echo "deb https://dl.bintray.com/ornis/CloudCompare {distribution} main" | sudo tee -a /etc/apt/sources.list
# echo "deb https://dl.bintray.com/ornis/CloudCompare xenial main" | sudo tee -a /etc/apt/sources.list
# sudo -E apt update && sudo -E apt -q -y install cloudcompare


sudo -E apt -q -y install libqt5svg5-dev

DIR="CloudCompare"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/CloudCompare/$DIR.git"
URL="https://github.com/cloudcompare/trunk.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  git clone --recurse-submodules -j8 $URL $PROG_DIR
  # git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake \
-D INSTALL_EXAMPLE_GL_PLUGIN=ON \
-D INSTALL_EXAMPLE_IO_PLUGIN=ON \
-D INSTALL_EXAMPLE_PLUGIN=ON \
-D INSTALL_QADDITIONAL_IO_PLUGIN=ON \
-D INSTALL_QANIMATION_PLUGIN=ON \
-D INSTALL_QBROOM_PLUGIN=ON \
-D INSTALL_QCORK_PLUGIN=OFF \
-D INSTALL_QCSF_PLUGIN=ON \
-D INSTALL_QCSV_MATRIX_IO_PLUGIN=ON \
-D INSTALL_QEDL_PLUGIN=ON \
-D INSTALL_QFACETS_PLUGIN=ON \
-D INSTALL_QHPR_PLUGIN=ON \
-D INSTALL_QM3C2_PLUGIN=ON \
-D INSTALL_QPCL_PLUGIN=ON \
-D INSTALL_QPCV_PLUGIN=ON \
-D INSTALL_QPHOTOSCAN_IO_PLUGIN=ON \
-D INSTALL_QPOISSON_RECON_PLUGIN=ON \
-D INSTALL_QRANSAC_SD_PLUGIN=ON \
-D INSTALL_QSRA_PLUGIN=ON \
-D INSTALL_QSSAO_PLUGIN=ON \
-D OPTION_BUILD_CCVIEWER=ON \
-D OPTION_GL_QUAD_BUFFER_SUPPORT=ON \
-D OPTION_PDAL_LAS=OFF \
-D OPTION_SUPPORT_GAMEPADS=OFF \
-D OPTION_SUPPORT_MAC_PDMS_FORMAT=OFF \
-D OPTION_USE_DXF_LIB=ON \
-D OPTION_USE_FBX_SDK=OFF \
-D OPTION_USE_GDAL=ON \
-D OPTION_USE_OCULUS_SDK=OFF \
-D OPTION_USE_SHAPE_LIB=ON \
-D WITH_FFMPEG_SUPPORT=OFF ..
# -D LIBE57FORMAT_INSTALL_DIR=/usr/local/E57Format-2.0-x86_64-linux-gcc55 \
# -D OPTION_USE_LIBE57FORMAT=ON \
# -D EIGEN_ROOT_DIR=$HOME/softwares/eigen/build \
# -D INSTALL_QCOMPASS_PLUGIN=OFF \
# -D INSTALL_QHOUGH_NORMALS_PLUGIN=OFF ..

# -D OPTION_SUPPORT_3DCONNEXION_DEV=OFF ..

## Note: not installing eigen to /usr/local as it may risk corrupting other dependend programs, infact most of them

## ccmake ..
make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


# rm -rf build && mkdir build && cd build/

##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

 # CMake Error at plugins/core/qCork/CorkSupport.cmake:13 (message):
 #   No Cork include dir specified (CORK_INCLUDE_DIR)
 # Call Stack (most recent call first):
 #   plugins/core/qCork/CMakeLists.txt:10 (include)



 # CMake Error at plugins/core/qCork/CorkSupport.cmake:25 (message):
 #   No MPIR include dir specified (MPIR_INCLUDE_DIR)
 # Call Stack (most recent call first):
 #   plugins/core/qCork/CMakeLists.txt:10 (include)



 # CMake Error at plugins/core/qCork/CorkSupport.cmake:61 (message):
 #   No Cork or MPIR release library files specified (CORK_RELEASE_LIBRARY_FILE
 #   / MPIR_RELEASE_LIBRARY_FILE)
 # Call Stack (most recent call first):
 #   plugins/core/qCork/CMakeLists.txt:14 (target_link_cork)


 # CMake Error at plugins/core/qAnimation/src/QTFFmpegWrapper/ffmpegSupport.cmake:13 (message):
 #   No ffmpeg include dir specified (FFMPEG_INCLUDE_DIR)
 # Call Stack (most recent call first):
 #   plugins/core/qAnimation/src/QTFFmpegWrapper/CMakeLists.txt:3 (include)



 # CMake Error at plugins/core/qAnimation/src/QTFFmpegWrapper/ffmpegSupport.cmake:45 (message):
 #   No ffmpeg library dir specified (FFMPEG_LIBRARY_DIR)
 # Call Stack (most recent call first):
 #   plugins/core/qAnimation/src/QTFFmpegWrapper/CMakeLists.txt:13 (target_link_ffmpeg)


# CMake Warning at contrib/PDALSupport.cmake:14 (message):
#    Jsoncpp root dir is not specified (JSON_ROOT_DIR)
#  Call Stack (most recent call first):
#    contrib/AllSupport.cmake:6 (include)
#    CMakeLists.txt:91 (include)



#  CMake Error at plugins/core/qCork/CorkSupport.cmake:13 (message):
#    No Cork include dir specified (CORK_INCLUDE_DIR)
#  Call Stack (most recent call first):
#    plugins/core/qCork/CMakeLists.txt:10 (include)



#  CMake Error at plugins/core/qCork/CorkSupport.cmake:25 (message):
#    No MPIR include dir specified (MPIR_INCLUDE_DIR)
#  Call Stack (most recent call first):
#    plugins/core/qCork/CMakeLists.txt:10 (include)



#  CMake Error at plugins/core/qCork/CorkSupport.cmake:61 (message):
#    No Cork or MPIR release library files specified (CORK_RELEASE_LIBRARY_FILE
#    / MPIR_RELEASE_LIBRARY_FILE)
#  Call Stack (most recent call first):
#    plugins/core/qCork/CMakeLists.txt:14 (target_link_cork)



 # CMake Warning at CC/CMakeLists.txt:26 (message):
 #   CCLib configured without parallel algorithm capabilities - see
 #   COMPILE_CC_CORE_LIB_WITH_TBB

 # CMake Warning at contrib/PDALSupport.cmake:14 (message):
 #   Jsoncpp root dir is not specified (JSON_ROOT_DIR)
 # Call Stack (most recent call first):
 #   contrib/AllSupport.cmake:6 (include)
 #   CMakeLists.txt:91 (include)



 # CMake Error at contrib/E57Support.cmake:12 (message):
 #   No libE57Format install dir specified (LIBE57FORMAT_INSTALL_DIR)
 # Call Stack (most recent call first):
 #   contrib/AllSupport.cmake:8 (include)
 #   CMakeLists.txt:91 (include)



 # CMake Error at contrib/E57Support.cmake:40 (message):
 #   Cannot find the libeE57Format library in /lib
 # Call Stack (most recent call first):
 #   contrib/AllSupport.cmake:8 (include)
 #   CMakeLists.txt:91 (include)

 # CMake Error at plugins/core/qCork/CorkSupport.cmake:13 (message):
 #   No Cork include dir specified (CORK_INCLUDE_DIR)
 # Call Stack (most recent call first):
 #   plugins/core/qCork/CMakeLists.txt:10 (include)



 # CMake Error at plugins/core/qCork/CorkSupport.cmake:25 (message):
 #   No MPIR include dir specified (MPIR_INCLUDE_DIR)
 # Call Stack (most recent call first):
 #   plugins/core/qCork/CMakeLists.txt:10 (include)



 # CMake Error at plugins/core/qCork/CorkSupport.cmake:61 (message):
 #   No Cork or MPIR release library files specified (CORK_RELEASE_LIBRARY_FILE
 #   / MPIR_RELEASE_LIBRARY_FILE)
 # Call Stack (most recent call first):
 #   plugins/core/qCork/CMakeLists.txt:14 (target_link_cork)



 # CMake Error at plugins/core/qHoughNormals/CMakeLists.txt:10 (message):
 #   No Eigen root directory specified (EIGEN_ROOT_DIR)




 # CMake Error at cmake/CMakeExternalLibs.cmake:22 (find_package):
 #   By not providing "FindQt5Svg.cmake" in CMAKE_MODULE_PATH this project has
 #   asked CMake to find a package configuration file provided by "Qt5Svg", but
 #   CMake did not find one.

 #   Could not find a package configuration file provided by "Qt5Svg" with any
 #   of the following names:

 #     Qt5SvgConfig.cmake
 #     qt5svg-config.cmake

 #   Add the installation prefix of "Qt5Svg" to CMAKE_PREFIX_PATH or set
 #   "Qt5Svg_DIR" to a directory containing one of the above files.  If "Qt5Svg"
 #   provides a separate development package or SDK, be sure it has been
 #   installed.
 # Call Stack (most recent call first):
 #   CC/CMakeLists.txt:32 (include)
