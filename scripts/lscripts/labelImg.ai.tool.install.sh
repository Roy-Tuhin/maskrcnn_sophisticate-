#!/bin/bash
##----------------------------------------------------------
## labelImg
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/tzutalin/labelImg.git
#
##----------------------------------------------------------

source ./lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS
DIR="labelImg"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/tzutalin/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

# ## py2
# sudo apt-get install pyqt4-dev-tools
# sudo pip install lxml
# make qt4py2
# python labelImg.py
# python labelImg.py [IMAGE_PATH] [PRE-DEFINED CLASS FILE]

## py3
# sudo apt-get install pyqt5-dev-tools
# sudo pip3 install -r requirements/requirements-linux-python3.txt
# make qt5py3
# python3 labelImg.py
# python3 labelImg.py [IMAGE_PATH] [PRE-DEFINED CLASS FILE]


cd $LINUX_SCRIPT_HOME
