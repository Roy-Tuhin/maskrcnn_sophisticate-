#!/bin/bash

##----------------------------------------------------------
## theano
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
# 
## http://www.chioka.in/how-to-setup-theano-to-run-on-gpu-on-ubuntu-14-04-with-nvidia-geforce-gtx-780/
## https://github.com/Theano/Theano/issues/6006
#
##----------------------------------------------------------


if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

pip install Theano>=0.8

source $LSCRIPTS/theano.install-test.sh
# source $LSCRIPTS/theano.config.sh
