#!/bin/bash

##----------------------------------------------------------
## Openproject
## Tested on Ubuntu 16.04
#
## https://www.openproject.org/download-and-installation/
## https://github.com/opf/openproject/blob/stable/7/docs/installation/manual/README.md
#
## https://computingforgeeks.com/how-to-install-openproject-community-edition-on-ubuntu-18-04-16-04-lts/
#
##----------------------------------------------------------

sudo apt-get install apt-transport-https

wget -qO- https://dl.packager.io/srv/opf/openproject-ce/key | sudo apt-key add -

## Ubuntu 18.04:
sudo wget -O /etc/apt/sources.list.d/openproject-ce.list https://dl.packager.io/srv/opf/openproject/dev/installer/ubuntu/18.04.repo


# ## Ubuntu 16.04:
# ## sudo wget -O /etc/apt/sources.list.d/openproject.list https://dl.packager.io/srv/opf/openproject-ce/stable/7/installer/ubuntu/16.04.repo
# sudo wget -O /etc/apt/sources.list.d/openproject-ce.list https://dl.packager.io/srv/opf/openproject/dev/installer/ubuntu/16.04.repo

sudo apt update
sudo apt -y install openproject
sudo openproject configure
