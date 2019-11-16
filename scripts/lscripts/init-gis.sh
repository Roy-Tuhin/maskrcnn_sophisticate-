#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

##----------------------------------------------------------
## GIS
##----------------------------------------------------------

# source protocolbuf.install.sh  ## git clone

# source proj.install.sh  ## wget
# source tiff.install.sh  ## wget
# source geotiff.install.sh  ## wget
# source laszip.install.sh  ## git clone
# source libkml.install.sh  ## git clone

# ###----------------------------------------------------------
# ## MySQL
# source mysql.install.sh  ## apt-get
# ## PostgreSQL
# source postgres.install.sh  ## apt-get
# ## rasdaman
# source rasdaman.db.install.sh
# ###----------------------------------------------------------


# # source suitesparse.install.sh ## complicated build process
source ceres-solver.install.sh  ## git clone

# ## Ubuntu 18.04 comes with Boost version: 1.65.1
# if [[ $LINUX_VERSION == "16.04" ]]; then
#   echo "...$LINUX_VERSION"
#   source boost.install.sh
# fi
# #
# ## source geowave.install.sh  ## not-yet-installed; huge size
# #
# source grass.gis.install.sh
# source gdal.install.sh  ## wget

# source libLAS.install.sh  ## git clone
# source laz-perf.install.sh  ## git clone
# source geos.install.sh  ## wget

# if [[ $LINUX_VERSION == "18.04" ]]; then
#   echo "$LINUX_VERSION"
#   source qgis3.install.sh
# fi
