#!/bin/bash

##----------------------------------------------------------
## Install utilities and softwares
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

sudo -E apt-get update

## Essential for New Machine Setup
sudo -E apt -q -y install git
sudo -E apt -q -y install gparted
sudo -E apt -q -y install net-tools
sudo -E apt -q -y install ppa-purge
