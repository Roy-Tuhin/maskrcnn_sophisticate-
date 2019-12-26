#!/bin/bash

##----------------------------------------------------------
## PROJ
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## PROJ is a cartographic projection library which most other GIS software depends on. It contains the share/proj/epsg file of the geospatial reference EPSG code numbers and allows for transformation of coordinates in different projection systems.
#
## http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#proj
## http://proj4.org/
## https://stackoPROJ_VERflow.com/questions/1078524/how-to-specify-the-location-with-wget
## https://stackoPROJ_VERflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
## https://stackoPROJ_VERflow.com/questions/638975/how-do-i-tell-if-a-regular-file-does-not-exist-in-bash
#
##----------------------------------------------------------


function proj_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh


  sudo apt install sqlite3

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="$HOME/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi
  if [ -z "${PROJ_VER}" ]; then
    PROJ_VER="4.9.3"
    echo "Unable to get PROJ_VER version, falling back to default version#: ${PROJ_VER}"
  fi

  PROG='proj'
  DIR="${PROG}-${PROJ_VER}"
  PROG_DIR="${BASEPATH}/${PROG}-${PROJ_VER}"
  FILE="${DIR}.tar.gz"

  URL=http://download.osgeo.org/proj/${FILE}

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo Not downloading as: ${HOME}/Downloads/${FILE} already exists!
  fi

  if [ ! -d ${PROG_DIR} ]; then
    tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH}
  else
    echo Extracted Dir already exists: ${PROG_DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}
  echo $(pwd)
  ##./configure --prefix=/opt/source/${PROG}-${PROJ_VER}/build
  ./configure

  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  # ln -s ${PROG_DIR} ${PROG}

  cd ${LSCRIPTS}
}

proj_install





# configure: error: Please install sqlite3 binary.
# make: *** No targets specified and no makefile found.  Stop.
# make: *** No rule to make target 'install'.  Stop.
