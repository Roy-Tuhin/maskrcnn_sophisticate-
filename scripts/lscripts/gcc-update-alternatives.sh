#!/bin/bash

##----------------------------------------------------------
## gcc, g++ multiple version configuration
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## -DCMAKE_C_COMPILER=/usr/bin/gcc-6 -DCMAKE_CXX_COMPILER=/usr/bin/g++-6
## https://stackoverflow.com/questions/39854114/set-gcc-version-for-make-in-shell
## make CC=gcc-4.4 CPP=g++-4.4 CXX=g++-4.4 LD=g++-4.4
#
## https://codeyarns.com/2015/02/26/how-to-switch-gcc-version-using-update-alternatives/
#
##----------------------------------------------------------

sudo -E apt -q -y install gcc-7 g++-7
# sudo -E apt -q -y install gcc-6 g++-6
# sudo -E apt -q -y install gcc-5 g++-5
# sudo -E apt -q -y install gcc-4.8 g++-4.8

##----------------------------------------------------------
#
### Alternative to update-alternative options is to create sym link
### I preferred update-alternatives option
#
##----------------------------------------------------------
## sudo ln -s /usr/bin/gcc-5 /usr/local/cuda/bin/gcc 
## sudo ln -s /usr/bin/g++-5 /usr/local/cuda/bin/g++
##----------------------------------------------------------

# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 200 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 150 --slave /usr/bin/g++ g++ /usr/bin/g++-5
# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 100 --slave /usr/bin/g++ g++ /usr/bin/g++-6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 50 --slave /usr/bin/g++ g++ /usr/bin/g++-7
sudo update-alternatives --config gcc
