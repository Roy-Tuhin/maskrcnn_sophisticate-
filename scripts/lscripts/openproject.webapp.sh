#!/bin/bash

##----------------------------------------------------------
## Openproject
## Tested on Ubuntu 16.04
#
## https://www.openproject.org/download-and-installation/
## https://github.com/opf/openproject/blob/stable/7/docs/installation/manual/README.md
#
##----------------------------------------------------------

wget -qO- https://dl.packager.io/srv/opf/openproject-ce/key | sudo apt-key add -
sudo apt-get install apt-transport-https

sudo wget -O /etc/apt/sources.list.d/openproject-ce.list \
  https://dl.packager.io/srv/opf/openproject-ce/stable/7/installer/ubuntu/16.04.repo

apt-get update
apt-get install openproject