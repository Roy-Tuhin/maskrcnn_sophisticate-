#!/bin/bash

##----------------------------------------------------------
## OpenCV
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## DOWNLOAD
## wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.2.0/opencv-3.2.0.zip
## wget https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz -O opencv_contrib-3.2.0.tar.gz
#
## mkdir -p ~/OpenCV
## git -C ~/OpenCV/opencv pull || git clone https://github.com/Itseez/opencv.git ~/OpenCV/opencv
## mkdir -p ~/OpenCV/opencv/build
## cd ~/OpenCV/opencv/build
#
## https://github.com/madhawav/YOLO3-4-Py/blob/master/tools/install_opencv34.sh
#
##----------------------------------------------------------


function opencv_get() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${OpenCV_REL}" ]; then
    local OpenCV_REL="3.3.0"
    local OpenCV_REL="3.4.1"
    echo "Unable to get OpenCV_REL version, falling back to default version#: ${OpenCV_REL}"
  fi

  local DIR='opencv'
  local PROG_DIR="${BASEPATH}/${DIR}"

  local URL="https://github.com/opencv/${DIR}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  git checkout ${OpenCV_REL}
  cd ${BASEPATH}

  local URL2="https://github.com/opencv/opencv_contrib.git"
  echo "URL2: ${URL2}"

  if [ ! -d ${BASEPATH}/opencv_contrib ]; then
    git -C ${BASEPATH}/opencv_contrib || git clone ${URL2} ${BASEPATH}/opencv_contrib
  else
    echo Git clone for ${URL2} exists at: ${BASEPATH}/opencv_contrib
  fi

  # git -C ${BASEPATH}/opencv_contrib || git clone https://github.com/opencv/opencv_contrib.git ${BASEPATH}/opencv_contrib

  cd ${BASEPATH}/opencv_contrib
  git checkout ${OpenCV_REL}

  ## cd ${BASEPATH}
  ## source ${LSCRIPTS}/opencv.compile.sh

  # cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  ## Errors

  # pyopengv.cpp:9:
  # /usr/include/c++/5/bits/c++0x_warning.h:32:2: error: #error This file requires compiler and library support for the ISO C++ 2011 standard. This support must be enabled with the -std=c++11 or -std=gnu++11 compiler options.
  #  #error This file requires compiler and library support \
    ^

  ## Fix::
  ## https://github.com/paulinus/opengv/blob/76a150fe1c5c6531034ed2caf2a4dd4e7835f163/python/CMakeLists.txt
  ## https://raw.githubusercontent.com/paulinus/opengv/76a150fe1c5c6531034ed2caf2a4dd4e7835f163/python/CMakeLists.txt
  # vi ./python/CMakeLists.txt
  # CXX_STANDARD 11
  # CXX_STANDARD_REQUIRED ON

  # set_target_properties(pyopengv PROPERTIES
  #     PREFIX ""
  #     SUFFIX ".so"
  #     CXX_STANDARD 11
  #     CXX_STANDARD_REQUIRED ON
  # )


  # /home/game/softwares/opengv/python/types.hpp:14:32: error: ‘numeric’ is not a namespace-name
  #  namespace bpn = boost::python::numeric;

  # Fix: Use boost 1.64.0
  # https://github.com/mapillary/OpenSfM/issues/212
}

opencv_get
