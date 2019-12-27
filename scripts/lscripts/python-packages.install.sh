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

function python_packages_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## Do not install python 2 packages by default as supports ends in Jan-2020
  # ## Install python packages using pip
  # echo ""
  # echo "sudo pip install -U -r python.requirements.txt"
  # echo ""
  # sudo pip install -U -r ${LSCRIPTS}/python.requirements.txt
  # echo "pip Python 2 packages:"
  # sudo pip list | grep -iE "numexpr|numpy|scipy|matplotlib|scikit-learn|Flask|pandas|sympy|networkx|scikit-image|statsmodels|seaborn|vtk|Mayavi|pylint|exifread|PyYAML|six|wheel"

  echo ""
  echo "sudo pip3 install -U -r python.requirements.txt"
  echo ""
  sudo pip3 install -U -r ${LSCRIPTS}/python.requirements.txt
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
}

python_packages_install
