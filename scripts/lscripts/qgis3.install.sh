#!/bin/bash
##----------------------------------------------------------
## qGIS 3
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/qgis/QGIS
## https://qgis.org/en/site/forusers/alldownloads.html#debian-ubuntu
## https://qgis.org/en/site/getinvolved/index.html
#
# Reference:
## https://scriptndebug.wordpress.com/2018/02/27/installing-qgis-3-on-ubuntu-16-04/
## https://gis.stackexchange.com/questions/272545/installing-qgis-3-0-on-ubuntu
#
## build from source: https://www.lutraconsulting.co.uk/blog/2017/08/06/qgis3d-build/
## https://qgis.org/en/site/forusers/alldownloads.html#debian-ubuntu
##----------------------------------------------------------
#
# wget -O - https://qgis.org/downloads/qgis-2017.gpg.key | gpg --import
# gpg --fingerprint CAEB3DC3BDF7FB45
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45
#
# sudo apt autoremove qgis
# sudo apt --purge remove qgis python-qgis qgis-plugin-grass
# sudo apt autoremove
# sudo apt update
# sudo apt install qgis python-qgis qgis-plugin-grass saga
#
##----------------------------------------------------------

# Download:
# https://qgis.org/debian/dists/bionic/main/

# Build Instructions
# https://htmlpreview.github.io/?https://github.com/qgis/QGIS/blob/master/doc/INSTALL.html#toc11

# Ref: https://linuxhint.com/install-qgis3-geospatial-ubuntu/
# add Ubuntu 18.04 specific repository of QGIS 3
sudo sh -c 'echo "deb https://qgis.org/debian bionic main" > /etc/apt/sources.list.d/qgis3.list'
# import the GPG key of QGIS 3 

# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 51F523511C7028C3

# wget -O - https://qgis.org/downloads/qgis-2017.gpg.key | sudo gpg --import

# # verify whether the GPG key was imported correctly
# gpg --fingerprint CAEB3DC3BDF7FB45
# # add the GPG key of QGIS 3 to apt package manager:
# gpg --export --armor CAEB3DC3BDF7FB45 | sudo apt-key add -

# https://gis.stackexchange.com/questions/332245/error-adding-qgis-org-repository-public-key-to-apt-keyring/332247  
# https://www.qgis.org/en/site/forusers/alldownloads.html

wget -O - https://qgis.org/downloads/qgis-2019.gpg.key | sudo gpg --import
# verify whether the GPG key was imported correctly
gpg --fingerprint 51F523511C7028C3
# add the GPG key of QGIS 3 to apt package manager:
gpg --export --armor 51F523511C7028C3 | sudo apt-key add -
# update the apt package repository cache
sudo -E apt -y update
# install QGIS 3
sudo -E apt install -y qgis python-qgis qgis-plugin-grass


# source ./lscripts.config.sh

# if [ -z "$BASEPATH" ]; then
#   BASEPATH="$HOME/softwares"
#   echo "Unable to get BASEPATH, using default path#: $BASEPATH"
# fi

# source ./numthreads.sh ##NUMTHREADS
# DIR="QGIS"
# PROG_DIR="$BASEPATH/$DIR"

# URL="https://github.com/qgis/$DIR.git"

# echo "Number of threads will be used: $NUMTHREADS"
# echo "BASEPATH: $BASEPATH"
# echo "URL: $URL"
# echo "PROG_DIR: $PROG_DIR"

# if [ ! -d $PROG_DIR ]; then
#   git -C $PROG_DIR || git clone $URL $PROG_DIR
# else
#   echo Git clone for $URL exists at: $PROG_DIR
# fi

# if [ -d $PROG_DIR/build ]; then
#   rm -rf $PROG_DIR/build
# fi

# mkdir $PROG_DIR/build
# cd $PROG_DIR/build
# cmake ..
# ccmake ..
# make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS



# qgis install following python libs, look into them

# python3-owslib
# python3-bs4
# python3-webencodings
# python3-html5lib
# python3-webencodings
# python3-lxml
# python3-pyparsing
# python3-cycler
# python3-bs4
# python3-gdal
# python3-jsonschema
# python3-psycopg2
# python3-future
# python3-ipython-genutils
# python3-jinja2
# python3-html5lib
# python3-sip
# python3-pyproj
# python3-traitlets
# python3-dateutil
# python3-pygments
# python3-jupyter-core
# python3-nbformat
# python3-owslib
# python3-pyqt5
# python3-plotly
# python3-pyqt5.qtwebkit
# python3-pyqt5.qtsvg
# python3-pyqt5.qtsql
# python3-matplotlib
# python3-pyqt5.qsci
# libqgispython3.4.1

# ##----------------------------------------------------------
# ### Build Error Log
# ##----------------------------------------------------------

# # Could not find GRASS 7
# # flex not found - aborting
