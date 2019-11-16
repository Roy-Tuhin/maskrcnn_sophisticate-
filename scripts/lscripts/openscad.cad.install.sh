#!/bin/bash

##----------------------------------------------------------
### OpenScad
##----------------------------------------------------------

# https://askubuntu.com/questions/327807/any-3d-cad-programs-for-ubuntu
#sudo -E add-apt-repository -y  ppa:chrysn/openscad
# http://www.openscad.org/
sudo -E add-apt-repository -y ppa:openscad/releases
sudo -E apt-get update
sudo -E apt-get -y install openscad
