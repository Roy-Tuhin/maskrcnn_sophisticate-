#!/bin/bash

##----------------------------------------------------------
### inkscape
## Tested on Ubuntu 16.04
##----------------------------------------------------------
# https://launchpad.net/~inkscape.dev/+archive/ubuntu/stable

sudo -E add-apt-repository -y ppa:inkscape.dev/stable
sudo -E apt -y update
sudo -E apt -q -y install inkscape
