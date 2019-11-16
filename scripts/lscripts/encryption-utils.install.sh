#!/bin/bash

##----------------------------------------------------------
### vim
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
#
## https://www.howtogeek.com/115955/how-to-quickly-encrypt-removable-storage-devices-with-ubuntu/
#
##----------------------------------------------------------
## WARNING
##----------------------------------------------------------
#
## * uses LUKS (Linux Unified Key Setup) encryption
## * encryption process will format the drive, deleting all data on it
## * encryption, which may not be compatible with other operating systems
## * he drive will be plug-and-play with any Linux system running the GNOME desktop
#
##----------------------------------------------------------

#sudo -E apt update
sudo -E apt -y install cryptsetup

