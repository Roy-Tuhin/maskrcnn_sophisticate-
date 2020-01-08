#!/bin/bash

# https://freefilesync.org/download/
# https://freefilesync.org/tutorials.php

function freefilesync_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "$FREEFILESYNC_VER" ]; then
    local FREEFILESYNC_VER="10.19"
    echo "Unable to get FREEFILESYNC_VER version, falling back to default version#: ${FREEFILESYNC_VER}"
  fi

  local PROG='FreeFileSync'
  local DIR=${PROG}
  local PROG_DIR="${BASEPATH}/${PROG}-${FREEFILESYNC_VER}"
  local FILE="${PROG}_${FREEFILESYNC_VER}_Linux.tar.gz"

  # local URL_SRC=https://freefilesync.org/download/${PROG}_${FREEFILESYNC_VER}_Source.zip
  # echo "URL_SRC: ${URL_SRC}"
  local URL=https://freefilesync.org/download/${FILE}

  # local FREEFILESYNC_VER=10.2
  # wget -c https://freefilesync.org/download/FreeFileSync_${FREEFILESYNC_VER}_Linux_64-bit.tar.gz

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo "Not downloading as: ${HOME}/Downloads/${FILE} already exists!"
  fi

  if [ ! -d ${BASEPATH}/${DIR} ]; then
    # tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #verbose
    tar xfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #silent mode
    echo "Extracting File: ${HOME}/Downloads/${FILE} here: ${BASEPATH}/${DIR}"
    echo "Extracting...DONE!"
  else
    echo "Extracted Dir already exists: ${BASEPATH}/${DIR}"
  fi

  # local LINE="export PATH="$PATH:"${BASEPATH}/${DIR}"
  # echo $LINE
  # grep -qF "${LINE}" "${FILE}" || echo "${LINE}" >> "${FILE}"
}

freefilesync_install
