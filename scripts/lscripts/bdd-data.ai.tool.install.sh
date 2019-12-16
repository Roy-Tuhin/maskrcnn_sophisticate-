#!/bin/bash
##----------------------------------------------------------
## BDD Toolkit
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/ucbdrive/bdd-data
## https://bdd-data.berkeley.edu/
## https://www.scalabel.ai/
#
## Install scalable
#
##----------------------------------------------------------

source ./lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS


DIR="bdd-data"
PROG_DIR="$BASEPATH/$DIR"

# https://github.com/ucbdrive/bdd-data.git
URL="https://github.com/ucbdrive/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

cd $LINUX_SCRIPT_HOME
