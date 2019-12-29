#!/bin/bash

##----------------------------------------------------------
### New system build semi-automation script
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

function init_photogrammetry() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  ##----------------------------------------------------------
  ## Photogrammetry pipeline Tools
  ##----------------------------------------------------------

  # source openscenegraph.install.sh  ## error in compilation 18.04 LTS

  ## deprecating, as not updated over 2 years now, need to see the real usage and alternate solutions
  ## source ${LSCRIPTS}/libght.install.sh
  ## source ${LSCRIPTS}/pgpointcloud.install.sh
  ## source ${LSCRIPTS}/hexer.pdal.install.sh

  source ${LSCRIPTS}/pdal.install.sh

  source ${LSCRIPTS}/entwine.install.sh  ## some error
  source ${LSCRIPTS}/simple-web-server.install.sh

  source ${LSCRIPTS}/vtk.install.sh

  source ${LSCRIPTS}/lopocs.pointcloud.install.sh

  source ${LSCRIPTS}/pcl.install.sh
  source ${LSCRIPTS}/opengv.install.sh

  source ${LSCRIPTS}/opencv.install.sh

  source ${LSCRIPTS}/openSfM.install.sh

  source ${LSCRIPTS}/cloudcompare.install.sh
  source ${LSCRIPTS}/vcglib.install.sh
  source ${LSCRIPTS}/meshlab.install.sh

  source ${LSCRIPTS}/opendronemap.install.sh
}

init_photogrammetry
