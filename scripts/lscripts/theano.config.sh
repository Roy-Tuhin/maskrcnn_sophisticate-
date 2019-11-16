#!/bin/bash

##----------------------------------------------------------
## theano
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
# 
## https://theano.readthedocs.io/en/master/install_ubuntu.html
#
##----------------------------------------------------------
## Quick test from commandline
##----------------------------------------------------------
## CPU:
## DEVICE="cuda" THEANO_FLAGS_CPU=mode=FAST_RUN,device=cpu,floatX=float32 python theano.install-test.py
#
## GPU with CUDA:
## DEVICE="cuda" THEANO_FLAGS=floatX=float32,device=cuda,optimizer=None,dnn.include_path=$CUDA_HOME/include,dnn.library_path=/usr/lib/x86_64-linux-gnu python theano.install-test.py
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

theano_config() {
  local FILE LINE
  local py

  if [[ -z "$1" ]]; then
      py=python
  else
      py=python$1
  fi

  FILE=$HOME/.bashrc
  #
  ## device
  LINE='export DEVICE="cuda"'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  #
  ## theano flags for CPU
  LINE='THEANO_FLAGS_CPU=mode=FAST_RUN,device=cpu,floatX=float32'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  #
  ## theano flags for GPU with CUDA
  LINE='THEANO_FLAGS=floatX=float32,device=cuda,optimizer=None,dnn.include_path=$CUDA_HOME/include,dnn.library_path=/usr/lib/x86_64-linux-gnu'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  #
  ## create theanopy for quick access: for GPU CUDA access
  LINE='alias theanopy="THEANO_FLAGS=$(echo $THEANO_FLAGS) python"'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  source $FILE

  THEANO_FLAGS=$(echo $THEANO_FLAGS) $py $LSCRIPTS/theano.install-test.py
  # THEANO_FLAGS=$(echo $THEANO_FLAGS) python theano.install-test.py
  THEANO_FLAGS_CPU=$(echo $THEANO_FLAGS_CPU) $py $LSCRIPTS/theano.install-test.py
}

theano_config $1

cd $LINUX_SCRIPT_HOME
