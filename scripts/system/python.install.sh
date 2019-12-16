#!/bin/bash

##----------------------------------------------------------
### Python
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://linuxize.com/post/how-to-install-python-3-7-on-ubuntu-18-04/
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
# echo ""
# echo "Checking for packages"
# # TBD read the package list from the python.requirements.txt file directly
# sudo pip list | grep -iE "numexpr|numpy|scipy|matplotlib|scikit-learn|Flask|pandas|sympy|networkx|scikit-image|statsmodels|seaborn|vtk|Mayavi|pylint|exifread|PyYAML|six|wheel"

## python package installation moved external to it to give more flexibility over installation
