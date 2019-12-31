#!/bin/bash

##----------------------------------------------------------
## PDAL - Point Data Abstraction Library
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://www.pdal.io
## https://www.pdal.io/download.html#debian
#
## Dependencies
## https://pdal.io/development/compilation/dependencies.html
##
## Notes:
##  1. If you are building both of these libraries yourself, make sure you build GDAL using the “External libgeotiff” option, which will prevent the insanity that can ensue on some platforms
##----------------------------------------------------------


function pdal_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${PDAL_REL}" ]; then
    local PDAL_REL="2.0.1"
    echo "Unable to get PDAL_REL version, falling back to default version#: ${PDAL_REL}"
  fi

  local DIR='PDAL'
  local PROG_DIR="${BASEPATH}/${DIR}"

  local URL="https://github.com/PDAL/${DIR}.git"

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
  git pull
  git checkout ${PDAL_REL}

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  make clean -j${NUMTHREADS}

  cmake -D WITH_LAZPERF=ON \
        -D WITH_LZMA=ON \
        -D BUILD_PLUGIN_PGPOINTCLOUD=ON \
        -D BUILD_PGPOINTCLOUD_TESTS=ON \
        -D BUILD_PLUGIN_SQLITE=ON \
        -D BUILD_SHARED_LIBS=ON \
        -D BUILD_SQLITE_TESTS=ON \
        -D BUILD_PLUGIN_PYTHON=ON ..

  # make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}

  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  # http://osgeo-org.1560.x6.nabble.com/pdal-PDAL-2-0-1-build-issue-td5415293.html

  # ./vendor/gtest/CMakeLists.txt:41:# ${gtest_BINARY_DIR}.
  # ./cmake/gtest.cmake:12:    LIBRARY_OUTPUT_DIRECTORY "${gtest_BINARY_DIR}/src"
  # ./cmake/gtest.cmake:16:    LIBRARY_OUTPUT_DIRECTORY "${gtest_BINARY_DIR}/src"

  ## Fix: https://github.com/PDAL/PDAL/issues/2857

  # [  8%] Linking CXX shared library /src/libgtest.so
  # /usr/bin/ld: cannot open output file /src/libgtest.so: No such file or directory
  # collect2: error: ld returned 1 exit status
  # vendor/gtest/CMakeFiles/gtest.dir/build.make:94: recipe for target '/src/libgtest.so' failed
  # make[2]: *** [/src/libgtest.so] Error 1
  # CMakeFiles/Makefile2:810: recipe for target 'vendor/gtest/CMakeFiles/gtest.dir/all' failed
  # make[1]: *** [vendor/gtest/CMakeFiles/gtest.dir/all] Error 2
  # make[1]: *** Waiting for unfinished jobs....
  # [  8%] Built target pdal_test_support
  # [  8%] Linking CXX static library ../../lib/libpdal_arbiter.a
  # [  8%] Built target pdal_arbiter
  # Makefile:162: recipe for target 'all' failed
  # make: *** [all] Error 2

}

pdal_install
