#!/bin/bash

##----------------------------------------------------------
## Boost
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Boost is a set of C++ libraries that many open source project depend on. Latest versions of boost may be required by development versions of some software (e.g. PCL and PDAL). Also see the official install instructions on the boost website. If installing boost with multiprocessor support, first install one of the MPI packages. 
## Boost is a set of libraries for the C++ programming language that provide support for tasks and structures such as linear algebra, pseudorandom number generation, multithreading, image processing, regular expressions, and unit testing. It contains over eighty individual libraries.
#
## http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#boost
## https://www.boost.org/users/download/
## https://en.wikipedia.org/wiki/Boost_(C%2B%2B_libraries)
## https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz
## https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz
#
## Ubuntu 18.04 comes with Boost version: 1.65.1
##----------------------------------------------------------


function boost_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${BOOST_VER}" ]; then  
    BOOST_VER="1.64.0"
    ## OpenGV does not compiles with 1.67.0 which is the prerequiste for OpenSfM: 
    # BOOST_VER="1.67.0"
    echo "Unable to get BOOST_VER version, falling back to default version#: ${BOOST_VER}"
  fi

  PROG='boost'
  DIR="boost_"$(echo ${BOOST_VER} | sed -e 's/\./_/g')
  PROG_DIR="${BASEPATH}/${DIR}"
  FILE="${DIR}.tar.gz"

  URL="https://dl.bintray.com/boostorg/release/${BOOST_VER}/source/${FILE}"

  echo "${URL}"
  echo "${FILE}"
  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL}  -P ${HOME}/Downloads
  else
    echo Not downloading as: ${HOME}/Downloads/${FILE} already exists!
  fi

  if [ ! -d ${PROG_DIR} ]; then
    tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH}
  else
    echo Extracted Dir already exists: ${PROG_DIR}
  fi

  cd ${PROG_DIR}

  sudo ./bootstrap.sh --prefix=/usr/local --with-libraries=all
  #sudo ./b2 install
  sudo ./b2 install -j${NUMTHREADS}

  # how-to-determine-the-boost-version-on-a-system
  echo 'find /usr -name "boost"'
  find /usr -name "boost"
  cat /usr/local/include/boost/version.hpp | grep BOOST_LIB_VERSION

  ## OpenSfM Dependencies
  # # export
  # # BOOST_ROOT="${HOME}/softwares/$DIR"
  # Boost_LIBRARYDIR="/usr/local/lib"
  # BOOST_INCLUDEDIR="/usr/local/include"

  # # not sure which worked
  # # this is required for OpenSfM to compile

  # #sudo ln -s libboost_python35.so.1.67.0 libboost_python.so
  # #sudo ln -s libboost_numpy35.so.1.67.0 libboost_numpy.so
  # sudo ln -s libboost_python35.so.${BOOST_VER} libboost_python.so
  # sudo ln -s libboost_numpy35.so.${BOOST_VER} libboost_numpy.so

  # sudo apt-get install libboost-python-dev
}

boost_install
