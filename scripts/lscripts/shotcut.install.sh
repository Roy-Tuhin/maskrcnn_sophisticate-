#!/bin/bash

##----------------------------------------------------------
### shotcut
## Video Editor
## https://shotcut.org/download/
## https://github.com/mltframework/shotcut/
##----------------------------------------------------------


function shotcut_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh


  local SHOTCUT_REL="v18.08"
  local FILE="shotcut-linux-x86_64-180801.tar.bz2"

  local SHOTCUT_REL="v19.12.31"
  local FILE="shotcut-linux-x86_64-191231.txz"

  local PROG='shotcut'
  local DIR=${PROG}-${SHOTCUT_REL}
  # local URL=https://github.com/mltframework/shotcut/releases/download/v19.12.31/shotcut-linux-x86_64-191231.txz
  local URL="https://github.com/mltframework/shotcut/releases/download/${SHOTCUT_REL}/${FILE}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo "Not downloading as: ${HOME}/Downloads/${FILE} already exists!"
  fi
  if [ ! -d ${BASEPATH}/${DIR} ]; then
    # tar xvfj $HOME/Downloads/$FILE -C $BASEPATH #verbose
    # tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #silent mode
    tar Jxvf ${HOME}/Downloads/${FILE} -C ${BASEPATH} #silent mode
    echo "Extracting File: ${HOME}/Downloads/${FILE} here: ${BASEPATH}/${DIR}"
    echo "Extracting...DONE!"
  else
    echo "Extracted Dir already exists: ${BASEPATH}/${DIR}"
  fi
}

shotcut_install

## launch the app
# /codehub/external/Shotcut/Shotcut.app/shotcut
