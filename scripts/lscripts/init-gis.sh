#!/bin/bash


function init_gis() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ##----------------------------------------------------------
  ## GIS
  ##----------------------------------------------------------

  source ${LSCRIPTS}/protocolbuf.install.sh  ## git clone

  source ${LSCRIPTS}/proj.install.sh  ## wget
  source ${LSCRIPTS}/tiff.install.sh  ## wget
  source ${LSCRIPTS}/geotiff.install.sh  ## wget
  source ${LSCRIPTS}/laszip.install.sh  ## git clone
  source ${LSCRIPTS}/libkml.install.sh  ## git clone

  ###----------------------------------------------------------
  ## MySQL
  source ${LSCRIPTS}/mysql.install.sh  ## apt-get

  ## PostgreSQL
  source ${LSCRIPTS}/postgres.install.sh  ## apt-get

  ## rasdaman
  source ${LSCRIPTS}/rasdaman.db.install.sh
  ###----------------------------------------------------------

  source ${LSCRIPTS}/suitesparse.install.sh ## complicated build process
  source ${LSCRIPTS}/ceres-solver.install.sh  ## git clone

  ## Ubuntu 18.04 comes with Boost version: 1.65.1
  if [[ $LINUX_VERSION == "16.04" ]]; then
    echo "...$LINUX_VERSION"
    source ${LSCRIPTS}/boost.install.sh
  fi

  #
  ## source ${LSCRIPTS}/geowave.install.sh  ## not-yet-installed; huge size
  #

  source ${LSCRIPTS}/grass.gis.install.sh
  source ${LSCRIPTS}/gdal.install.sh  ## wget

  source ${LSCRIPTS}/libLAS.install.sh  ## git clone
  source ${LSCRIPTS}/laz-perf.install.sh  ## git clone
  source ${LSCRIPTS}/geos.install.sh  ## wget

  if [[ $LINUX_VERSION == "18.04" ]]; then
    echo "$LINUX_VERSION"
    source ${LSCRIPTS}/qgis3.install.sh
  fi
}

init_gis
