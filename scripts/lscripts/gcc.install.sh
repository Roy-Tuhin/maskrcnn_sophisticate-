#!/bin/bash

##----------------------------------------------------------
## gcc, g++ multiple version configuration
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## -DCMAKE_C_COMPILER=/usr/bin/gcc-6 -DCMAKE_CXX_COMPILER=/usr/bin/g++-6
## https://stackoverflow.com/questions/39854114/set-gcc-version-for-make-in-shell
## make CC=gcc-4.4 CPP=g++-4.4 CXX=g++-4.4 LD=g++-4.4
#
## https://codeyarns.com/2015/02/26/how-to-switch-gcc-version-using-update-alternatives/
#
##----------------------------------------------------------

sudo -E apt -q -y install gcc-7 g++-7
sudo -E apt -q -y install gcc-6 g++-6
sudo -E apt -q -y install gcc-5 g++-5
sudo -E apt -q -y install gcc-4.8 g++-4.8


function gcc_update_alternatives() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${SCRIPTS_DIR}/gcc-update-alternatives.sh
}

gcc_update_alternatives
