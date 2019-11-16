#!/bin/bash

##----------------------------------------------------------
## imagemagick
## Tested on Ubuntu 16.04 LTS
#
## https://www.theshell.guru/install-imagemagick-ubuntu-16-04/
##----------------------------------------------------------

# Don't remove image magic - imagemagick may be a dependency for other pieces of software run

# sudo apt remove --purge imagemagick
apt-cache showpkg imagemagick
sudo -E apt update
sudo -E apt -q -y install imagemagick
# for php
sudo -E apt -q -y install php-imagick
