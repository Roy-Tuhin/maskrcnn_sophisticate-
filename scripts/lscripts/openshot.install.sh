#!/bin/bash

##----------------------------------------------------------
### openshot
# Video Editor
##----------------------------------------------------------
# https://www.openshot.org/

sudo -E add-apt-repository -y ppa:openshot.developers/ppa
sudo -E apt -y update
sudo apt-get install -y openshot-qt
