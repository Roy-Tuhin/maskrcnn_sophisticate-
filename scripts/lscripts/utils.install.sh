#!/bin/bash

##----------------------------------------------------------
### Install utilities and softwares
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

## moved to utils.core.install.sh
#sudo -E apt update

## Essential for New Machine Setup
#sudo -E apt -q -y install git
#sudo -E apt -q -y install gparted

# source ./utils.core.install.sh
##
sudo -E apt -q -y install openssh-client openssh-server
sudo -E apt -q -y install dos2unix
sudo -E apt -q -y install tree
sudo -E apt -q -y install chromium-browser
sudo -E apt -q -y install unrar
sudo -E apt -q -y install aptitude
### exif tool
sudo -E apt -q -y install libimage-exiftool-perl
## Used in openCV
sudo -E apt -q -y install doxygen doxygen-gui
sudo -E apt -q -y install graphviz
## Misc
sudo -E apt -q -y install libexif-dev
sudo -E apt -q -y install ntp
sudo -E apt -q -y install libconfig++-dev
sudo -E apt -q -y install kino
## for software builds
sudo -E apt -q -y install cmake-curses-gui
##Admin
#system utils: htop
sudo -E apt -q -y install htop
sudo -E apt -q -y install apcalc

# For gnome Ubuntu >= 17
sudo -E apt -q -y install gnome-tweak-tool

## TBD: >= check
# Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  echo $LINUX_VERSION
fi

## sudo apt install gnome-shell-extension-weather
## start gnome-tweaks by
# gnome-tweaks

sudo -E apt -q -y install dconf-editor

# cmd image viewer
sudo -E apt -q -y install feh


# openvpn
sudo -E apt -q -y install openvpn

# * Enabe "New Document" Option
# https://linuxconfig.org/how-to-create-desktop-shortcut-launcher-on-ubuntu-18-04-bionic-beaver-linux
touch $HOME/Templates/Empty\ Document

## https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo
sudo -E apt -q -y install subversion
sudo -E apt -q -y install libcanberra-gtk-module

if [[ $LINUX_ID == 'Kali' ]]; then
  sudo apt -y install pepperflashplugin-nonfree
  sudo apt -y install libreoffice
  ## PDF viewer
  sudo apt -y install evince
  ## Enable network browser in Thunar File Browser
  sudo apt -y install gvfs-backends gvfs-bin gvfs-fuse
  ## Fix for: error while loading shared libraries: libgconf-2.so.4: cannot open shared object file: No such file or directory
  sudo apt -y install libgconf-2-4
fi