#!/bin/bash

##----------------------------------------------------------
### sublime-text editor
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://ubuntuhandbook.org/index.php/2013/12/install-sublime-text-3-ubuntu-14-04-trusty/
#
##----------------------------------------------------------

#sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
#sudo -E apt-get update
#sudo -E apt-get -q -y install sublime-text-installer

##----------------------------------------------------------
### Official Linux Repo setup
### https://www.sublimetext.com/docs/3/linux_repositories.html
##----------------------------------------------------------

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo -E apt -q -y install apt-transport-https
## Stable
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
## Dev
#echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo -E apt update
sudo -E apt -q -y install sublime-text

