#!/bin/bash

##----------------------------------------------------------
### vcglib
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/cnr-isti-vclab/vcglib
#
## Refer meshlab compilation from sources
## https://github.com/cnr-isti-vclab/meshlab/tree/master/src
#
##----------------------------------------------------------


function vcglib_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  local DIR="vcglib"
  local PROG_DIR="${BASEPATH}/${DIR}"

  local URL="https://github.com/cnr-isti-vclab/${DIR}.git"

  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then  
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  local VCGLIB_REL="v1.0.1"

  cd ${PROG_DIR}
  git pull
  git checkout ${VCGLIB_REL}

  # cd ${LSCRIPTS}

  ## https://github.com/cnr-isti-vclab/meshlab/issues/258
  ## meslab requires it to be present at the same level for compilation
}

vcglib_install
