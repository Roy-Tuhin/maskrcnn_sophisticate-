#!/bin/bash

##----------------------------------------------------------
## Haroopad
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://pad.haroopress.com/user.html
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$HAROOPAD_VER" ]; then
  HAROOPAD_VER="0.13.1"
  echo "Unable to get HAROOPAD_VER version, falling back to default version#: $HAROOPAD_VER"
fi

sudo -E apt -q -y install libgconf2-4

PROG='haroopad'
FILE="$PROG-v$HAROOPAD_VER-x64.deb"
echo "$FILE"

if [ ! -f $HOME/Downloads/$FILE ]; then
  #wget https://bitbucket.org/rhiokim/haroopad-download/downloads/haroopad-v0.13.1-x64.deb
  wget https://bitbucket.org/rhiokim/haroopad-download/downloads/$FILE -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

sudo dpkg -i $HOME/Downloads/$FILE
