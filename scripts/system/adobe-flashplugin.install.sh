#!/bin/bash

##----------------------------------------------------------
### Install utilities and softwares
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Installing Adobe Flash Player and Plugin for browser
## https://websiteforstudents.com/installing-the-latest-flash-player-on-ubuntu-17-10/
#
##----------------------------------------------------------

sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo -E apt update
sudo -E apt -q -y install adobe-flashplugin browser-plugin-freshplayer-pepperflash


