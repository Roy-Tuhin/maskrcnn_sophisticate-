#!/bin/bash

##----------------------------------------------------------
## OpenCV
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------


function opencv_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  source ${LSCRIPTS}/opencv.prerequisite.sh

  ## Download
  source ${LSCRIPTS}/opencv.get.sh

  ## Compile and Build
  # source ${LSCRIPTS}/opencv.compile.sh
}

opencv_install
