#!/bin/bash

##----------------------------------------------------------
### Scribus
##----------------------------------------------------------
# * https://askubuntu.com/questions/825391/install-scribus-1-5-on-ubuntu-16-04
#
##----------------------------------------------------------

LSCRIPTS=$(pwd)
cd $LSCRIPTS

source $LSCRIPTS/linuxscripts.config.sh

if [[ $LINUX_VERSION == "16.04" ]]; then
  sudo -E add-apt-repository -y ppa:scribus/ppa
  sudo apt update
  sudo apt install -y scribus-ng
fi

# Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  sudo apt install -y scribus scribus-template scribus-doc
fi
