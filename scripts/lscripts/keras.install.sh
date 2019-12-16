#!/bin/bash

##----------------------------------------------------------
### keras
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://www.pyimagesearch.com/2016/07/18/installing-keras-for-deep-learning/
## https://www.pyimagesearch.com/2017/09/25/configuring-ubuntu-for-deep-learning-with-python/
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

# sudo apt-get -y install python-yaml 
# sudo apt-get -y libhdf5-serial-dev
sudo pip install -U numpy scipy matplotlib scikit-learn h5py

##sudo pip install -d $HOME/Downloads/pip-cache keras
sudo pip install keras

sudo pip3 install -U  numpy scipy matplotlib scikit-learn h5py

##sudo pip3 install -d $HOME/Downloads/pip-cache keras
sudo pip3 install keras

#Successfully installed scipy matplotlib scikit-learn python-dateutil functools32 subprocess32 pytz cycler
#Successfully installed keras theano

cd $LINUX_SCRIPT_HOME
