#!/bin/bash

##----------------------------------------------------------
### Markdown Editors
##----------------------------------------------------------

# http://remarkableapp.github.io/linux/download.html
# https://github.com/shd101wyy/markdown-preview-enhanced
wget http://remarkableapp.github.io/files/remarkable_1.87_all.deb
sudo apt-get -y install gir1.2-webkit-3.0 wkhtmltopdf
sudo apt-get -f install
sudo dpkg -i ~/Downloads/remarkable_1.87_all.deb

