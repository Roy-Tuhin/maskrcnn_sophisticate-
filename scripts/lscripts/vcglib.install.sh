#!/bin/bash

##----------------------------------------------------------
### vcglib
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/cnr-isti-vclab/vcglib
#
## Refer meshlab compilation from sources
## https://github.com/cnr-isti-vclab/meshlab/tree/master/src
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

DIR="vcglib"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/cnr-isti-vclab/$DIR.git"

echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then  
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  # https://github.com/cnr-isti-vclab/meshlab/issues/258
  git checkout devel
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

# cd $LINUX_SCRIPT_HOME

## meslab requires it to be present at the same level for compilation