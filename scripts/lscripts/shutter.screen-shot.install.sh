#!/bin/bash

##----------------------------------------------------------
### shutter
##----------------------------------------------------------
# * http://shutter-project.org/about/
# * http://tipsonubuntu.com/2015/04/13/install-the-latest-shutter-screenshot-tool-in-ubuntu/
# * http://lightscreen.com.ar/
#
# * http://ubuntuhandbook.org/index.php/2018/10/how-to-install-shutter-screenshot-tool-in-ubuntu-18-10/
#
##----------------------------------------------------------

LSCRIPTS=$(pwd)
cd $LSCRIPTS

source $LSCRIPTS/linuxscripts.config.sh

if [[ $LINUX_VERSION == "16.04" ]]; then
  sudo -E add-apt-repository -y ppa:shutter/ppa
  sudo -E apt update
  sudo -E apt -q -y install shutter
fi

# Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  sudo -E add-apt-repository -y ppa:ubuntuhandbook1/shutter
  sudo -E apt -q -y install shutter
fi

## To uninstall
# sudo -E apt remove --autoremove shutter

## And go to Software & Updates -> Other Software to remove third-party PPA repositories.

## For kali Linux Screenshot utilities, also available on Ubuntu
## https://blog.anantshri.info/content/uploads/2010/09/add-apt-repository.sh.txt
sudo apt -y install scrot screengrab
