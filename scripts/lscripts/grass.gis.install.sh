#!/bin/bash

##----------------------------------------------------------
### GRASS GIS
##----------------------------------------------------------

## Grass
# https://grass.osgeo.org/download/software/linux/

# Install
## In Ubuntu 18/04 LTS
## E: The repository 'http://ppa.launchpad.net/grass/grass-stable/ubuntu bionic Release' does not have a Release file.

# sudo -E add-apt-repository -y ppa:grass/grass-stable

sudo -E apt -y update
sudo -E apt -y install grass

#sudo -E apt -y install ppa:grass/grass-stable
