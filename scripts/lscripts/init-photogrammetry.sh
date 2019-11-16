#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

##----------------------------------------------------------
## Photogrammetry pipeline Tools
##----------------------------------------------------------

# source openscenegraph.install.sh  ## error in compilation 18.04 LTS

source $LSCRIPTS/libght.install.sh
source $LSCRIPTS/pgpointcloud.install.sh

source $LSCRIPTS/hexer.pdal.install.sh
source $LSCRIPTS/pdal.install.sh

source $LSCRIPTS/entwine.install.sh  ## some error
source $LSCRIPTS/simple-web-server.install.sh

source $LSCRIPTS/vtk.install.sh

source $LSCRIPTS/lopocs.pointcloud.install.sh

source $LSCRIPTS/pcl.install.sh
source $LSCRIPTS/opengv.install.sh

source $LSCRIPTS/opencv.install.sh

source $LSCRIPTS/openSfM.install.sh

source $LSCRIPTS/cloudcompare.install.sh
source $LSCRIPTS/vcglib.install.sh
source $LSCRIPTS/meshlab.install.sh

source $LSCRIPTS/opendronemap.install.sh
