#!/bin/bash

##----------------------------------------------------------
## OpenGV
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://laurentkneip.github.io/opengv
## https://github.com/laurentkneip/opengv
#
## https://github.com/paulinus/opengv
#
## dependency to OpenSfM
## https://laurentkneip.github.io/opengv/page_installation.html
## Fix::
## https://github.com/paulinus/opengv/blob/76a150fe1c5c6531034ed2caf2a4dd4e7835f163/python/CMakeLists.txt
## https://raw.githubusercontent.com/paulinus/opengv/76a150fe1c5c6531034ed2caf2a4dd4e7835f163/python/CMakeLists.txt
# vi ./python/CMakeLists.txt
# CXX_STANDARD 11
# CXX_STANDARD_REQUIRED ON
#
# set_target_properties(pyopengv PROPERTIES
#     PREFIX ""
#     SUFFIX ".so"
#     CXX_STANDARD 11
#     CXX_STANDARD_REQUIRED ON
# )
#
##----------------------------------------------------------


function opengv_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  local DIR="opengv"
  local PROG_DIR="${BASEPATH}/${DIR}"

  ### 1.67.0 has problem compiling with boost python
  ## URL="https://github.com/laurentkneip/${DIR}"

  ### https://github.com/mapillary/OpenSfM/issues/212
  local URL="https://github.com/paulinus/${DIR}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  # git submodule update --init --recursive

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  ## enable PYTHON for openSfM
  cmake -DBUILD_PYTHON=ON \
        -DCMAKE_EXE_LINKER_FLAGS=-L/usr/local/lib \
        -DCMAKE_CXX_FLAGS=-I/usr/local/include \
        -DCMAKE_C_FLAGS="-I/usr/local/include -L/usr/local/lib" \
        -DBUILD_SHARED_LIBS=ON ..

  ## ccmake ..

  # make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  # -- Found Eigen: /usr/include/eigen3 (Required is at least version "2.91.0") 
  # CMake Error at python/CMakeLists.txt:2 (add_subdirectory):
  #   The source directory

  #     /codehub/external/opengv/python/pybind11

  #   does not contain a CMakeLists.txt file.


  # CMake Error at python/CMakeLists.txt:7 (pybind11_add_module):
  #   Unknown CMake command "pybind11_add_module".

  # git submodule update --init --recursive
  ##----------------------------------------------------------

  # https://stackoverflow.com/questions/5327325/conflict-between-boost-opencv-and-eigen-libraries

  # [ 72%] Building CXX object CMakeFiles/test_eigensolver.dir/test/test_eigensolver.cpp.o
  # In file included from /home/bhaskar/softwares/opengv/python/pyopengv.cpp:14:0:
  # /home/bhaskar/softwares/opengv/python/types.hpp:14:32: error: ‘numeric’ is not a namespace-name
  #  namespace bpn = boost::python::numeric;
  #                                 ^~~~~~~
  # /home/bhaskar/softwares/opengv/python/types.hpp:14:39: error: expected namespace-name before ‘;’ token
  #  namespace bpn = boost::python::numeric;
#                                        ^
}

opengv_install
