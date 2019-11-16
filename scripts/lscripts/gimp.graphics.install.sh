#!/bin/bash

##----------------------------------------------------------
### gimp
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

## Gimp
# http://ubuntuhandbook.org/index.php/2015/11/how-to-install-gimp-2-8-16-in-ubuntu-16-04-15-10-14-04/

# Install
sudo -E add-apt-repository -y ppa:otto-kesselgulasch/gimp
sudo -E apt -y update
sudo -E apt -q -y install gimp

# Uninstall.
#sudo -E apt -q -y install ppa-purge
#sudo ppa-purge ppa:otto-kesselgulasch/gimp
