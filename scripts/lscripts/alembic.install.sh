#!/bin/bash

##----------------------------------------------------------
## alembic
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
## Alembic is an open computer graphics interchange framework. Alembic distills complex, animated scenes into a non-procedural, application-independent set of baked geometric results.
#
## https://github.com/alembic/alembic/releases
## http://www.alembic.io/
#
##----------------------------------------------------------


function alembic_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${ALEMBIC_REL}" ]; then
    local ALEMBIC_REL="1.7.12"
    echo "Unable to get ALEMBIC_REL version, falling back to default version#: ${ALEMBIC_REL}"
  fi

  local DIR="ALEMBIC"
  local PROG_DIR="${BASEPATH}/${DIR}-${ALEMBIC_REL}"

  local URL="https://github.com/alembic/${DIR}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Gid clone for ${URL} exists at: ${PROG_DIR}
  fi

  # http://faculty.cse.tamu.edu/davis/suitesparse.html

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  cd ${PROG_DIR}
  git pull
  git checkout ${ALEMBIC_REL}

  mkdir ${PROG_DIR}/build

  ## https://github.com/alicevision/AliceVisionDependencies/blob/master/ci/install-ceres.sh
  cd ${PROG_DIR}/build
  cmake -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_FLAGS="-I/usr/local/include -DEIGEN_DONT_ALIGN_STATICALLY=1 -DEIGEN_DONT_VECTORIZE=1" \
        -DCMAKE_EXE_LINKER_FLAGS=-L/usr/local/lib \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local ..

  ## not required
  # ccmake ..

  make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

}

alembic_install
