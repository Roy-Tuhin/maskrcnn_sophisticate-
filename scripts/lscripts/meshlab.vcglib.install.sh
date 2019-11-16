#!/bin/bash

##----------------------------------------------------------
### meshlab
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://www.meshlab.net
#
## Compiling from sources
## https://github.com/cnr-isti-vclab/meshlab/tree/master/src
#
## Compiling MeshLab
## 1. install Qt5.9, be sure to select additional packages "script" and "xmlpatterns"
## 2. clone meshlab repo
## 3. clone vcglib repo (devel branch) at the same level of meshlab
## 4. compile src/external/external.pro,
## 5. compile src/meshlab_full.pro
#
## http://linuxg.net/how-to-install-meshlab-1-3-3-on-ubuntu-linux-mint-and-elementary-os-via-ppa/
#
##----------------------------------------------------------

source ./vcglib.install.sh
source ./meshlab.install.sh