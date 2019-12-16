#!/bin/bash

##----------------------------------------------------------
## geowave
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
##  GeoWave is working to bridge geospatial software with distributed compute systems
#
## https://github.com/locationtech/geowave
## https://locationtech.github.io/geowave/devguide.html
# ls -lah geowave
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi
if [ -z "$GEOWAVE_REL_TAG" ]; then
  GEOWAVE_REL_TAG="v0.9.7"
  echo "Unable to get GEOWAVE_REL_TAG version, falling back to default version#: $GEOWAVE_REL_TAG"
fi

DIR="geowave"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/locationtech/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  cd $PROG_DIR
  git checkout $GEOWAVE_REL_TAG
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

cd $PROG_DIR
# mvn clean install
mvn clean install -Dfindbugs.skip=true -Dformatter.skip=true -DskipITs=true -DskipTests=true

cd $LINUX_SCRIPT_HOME
