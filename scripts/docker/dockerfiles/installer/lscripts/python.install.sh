#!/bin/bash

##----------------------------------------------------------
### Python
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## TBD:
## - use update alternative for multiple python2 version or python3 version
##   - https://askubuntu.com/questions/609623/enforce-a-shell-script-to-execute-a-specific-python-version
## Change List
##----------------------------------------------------------
## 06-Jul-2018
# 1. apt-get replaced with apt
##----------------------------------------------------------

# By default, both python2 and python3 are installed.

#apt-cache policy python
#sudo -E apt -q -y install python-pip python-dev

# https://www.learnopencv.com/installing-deep-learning-frameworks-on-ubuntu-with-cuda-support/

# install python 2 and 3 along with other important packages
sudo -E apt -q -y install --no-install-recommends libboost-all-dev doxygen
sudo -E apt -q -y install libgflags-dev libgoogle-glog-dev liblmdb-dev libblas-dev 
sudo -E apt -q -y install libatlas-base-dev libopenblas-dev libgphoto2-dev libeigen3-dev libhdf5-dev 

##suugested when installing above on Ubuntu 18
#libatlas-doc liblapack-doc libeigen3-doc libmrpt-dev libhdf5-doc

sudo -E apt -q -y install python-dev python-pip python-nose python-numpy python-scipy
sudo -E apt -q -y install python3-dev python3-pip python3-nose python3-numpy python3-scipy


## pip basic Usage:
pip --version
pip3 --version
echo ""
echo ""
echo "sudo pip install -U -r python.requirements.txt"
echo "sudo pip3 install -U -r python.requirements.txt"
echo ""
echo "Checking for packages"
# TBD read the package list from the python.requirements.txt file directly
sudo pip list | grep -iE "numexpr|numpy|scipy|matplotlib|scikit-learn|Flask|pandas|sympy|networkx|scikit-image|statsmodels|seaborn|vtk|Mayavi|pylint|exifread|PyYAML|six|wheel"

if [ -z $LSCRIPTS ];then
  $LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

## Install python packages using pip
sudo pip install -U -r $LINUX_SCRIPT_HOME/python.requirements.txt
echo "pip Python 2 packages:"
sudo pip list | grep -iE "numexpr|numpy|scipy|matplotlib|scikit-learn|Flask|pandas|sympy|networkx|scikit-image|statsmodels|seaborn|vtk|Mayavi|pylint|exifread|PyYAML|six|wheel"

sudo pip3 install -U -r $LINUX_SCRIPT_HOME/python.requirements.txt
echo "pip Python 3 packages:"
sudo pip3 list | grep -iE "numexpr|numpy|scipy|matplotlib|scikit-learn|Flask|pandas|sympy|networkx|scikit-image|statsmodels|seaborn|vtk|Mayavi|pylint|exifread|PyYAML|six|wheel"


# pip search KEYWORD
# pip install PACKAGE_NAME
# pip uninstall PACKAGE_NAME


# #python --version
# Python 2.7.15rc1
# #python3 --version
# Python 3.6.5
# #which python
# /usr/bin/python
# #which python3
# /usr/bin/python3
# #pip3 --version
# pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)
# #pip --version
# pip 9.0.1 from /usr/lib/python2.7/dist-packages (python 2.7)

#python --version
#python3 -V
#pip -V
# pip install -U pip setuptools
# pip install --upgrade pip

##### pip modules

###### test module
# pip install nose

###### csv to elasticsearch
#pip install csv2es

## will run it in python 2
#!/usr/bin/env python

## will run it in python 3
#!/usr/bin/env python3
