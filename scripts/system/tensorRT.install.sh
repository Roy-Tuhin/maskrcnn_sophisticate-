#!/bin/bash

##----------------------------------------------------------
### TensorRT Installation
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://developer.nvidia.com/tensorrt
## https://developer.nvidia.com/nvidia-tensorrt-4x-download
#
##----------------------------------------------------------


if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi


if [ -f $HOME/Downloads/$tensorRTFILE ]; then
  # Install runtime lib
  sudo dpkg -i $HOME/Downloads/$tensorRTFILE

  sudo -E apt update
  sudo -E apt -q -y install tensorrt

  ## Developer Installation: The following instructions sets up a full TensorRT development environment with samples, documentation and both the C++ and Python API.
  # Python 2.7+
  sudo -E apt -q -y install python-libnvinfer-doc swig

  # Python 3.5
  sudo -E apt -q -y install python3-libnvinfer-doc

  ## In either case:
  sudo -E apt -q -y install uff-converter-tf

  ## Verify
  dpkg -l | grep TensorRT

  ## App Server Installation: When setting up servers which will host TensorRT powered applications, you can simply install any of the following
  sudo -E apt -q -y install libnvinfer
else
  echo "File Does NOT Exists: $HOME/Downloads/$tensorRTFILE"
fi

