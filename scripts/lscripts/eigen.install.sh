#!/bin/bash

##----------------------------------------------------------
## Eigen
## Tested on Ubuntu 16.04 LTS, 18.04 LTS
##----------------------------------------------------------
#
## Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms.
#
## http://eigen.tuxfamily.org/index.php?title=Main_Page
## https://github.com/eigenteam/eigen-git-mirror
#
## https://gitlab.com/libeigen/eigen/blob/master/INSTALL
## Eigen consists only of header files, hence there is nothing to compile
## before you can use it. Moreover, these header files do not depend on your
## platform, they are the same for everybody.
#
##----------------------------------------------------------

function eigen_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi
  if [ -z "${EIGEN_REL}" ]; then
    local EIGEN_REL="3.3.5"
    echo "Unable to get EIGEN_REL version, falling back to default version#: ${EIGEN_REL}"
  fi

  local PROG='eigen'
  local DIR="${PROG}"
  local PROG_DIR="${BASEPATH}/${PROG}"

  # local URL="https://github.com/eigenteam/${DIR}-git-mirror.git"
  local URL="https://gitlab.com/libeigen/${DIR}.git"

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
  git checkout ${EIGEN_REL}

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  # # cmake ..
  cmake -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_EXE_LINKER_FLAGS=-L/usr/local/lib \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_CXX_FLAGS=-I/usr/local/include \
    -DCMAKE_C_FLAGS="-I/usr/local/include -L/usr/local/lib" ..

  make install
  ## ccmake ..
  # make -j${NUMTHREADS}

  ## Note: not installing eigen to /usr/local as it may risk corrupting other dependend programs, infact most of them
  # sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}
}

eigen_install
