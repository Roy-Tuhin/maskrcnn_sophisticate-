#!/bin/bash
##----------------------------------------------------------
# uncertaintyTE
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/alicevision/uncertaintyTE.git
#
##----------------------------------------------------------


function uncertaintyte_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi


  local PROG="uncertaintyTE"
  local DIR="${PROG}"
  local PROG_DIR="${BASEPATH}/${PROG}"

  local URL="https://github.com/alicevision/${PROG}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: $URL"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    ## git version 1.6+
    # git clone --recursive $URL

    ## git version >= 2.8
    # git clone --recurse-submodules -j8 $URL ${PROG_DIR}
    git -C ${PROG_DIR} || git clone $URL ${PROG_DIR}
  else
    echo Git clone for $URL exists at: ${PROG_DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  cmake ..
  # make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------
}

uncertaintyte_install
