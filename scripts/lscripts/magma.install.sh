#!/bin/bash
##----------------------------------------------------------
# Magma
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://icl.utk.edu/magma/software/index.html
#
## MAGMA provides implementations for CUDA, Intel Xeon Phi, and OpenCL. The latest releases are MAGMA 2.5, MAGMA MIC 1.4.0, and clMAGMA 1.3, respectively. The libraries available for download are listed below in the order of their release dates.
#
##----------------------------------------------------------


function magma_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi
  if [ -z "${MAGMA_VER}" ]; then
    local MAGMA_VER="2.5.2"
    echo "Unable to get MAGMA_VER version, falling back to default version#: ${MAGMA_VER}"
  fi

  local PROG='magma'
  local DIR="${PROG}-${MAGMA_VER}"
  local PROG_DIR="${BASEPATH}/${PROG}-${MAGMA_VER}"
  local FILE="${DIR}.tar.gz"

  local URL="http://icl.utk.edu/projectsfiles/magma/downloads/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo Not downloading as: ${HOME}/Downloads/${FILE} already exists!
  fi

  if [ ! -d ${HOME}/softwares/$DIR ]; then
    tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH}
  else
    echo Extracted Dir already exists: ${BASEPATH}/${DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  cmake ..
  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------
}

magma_install
