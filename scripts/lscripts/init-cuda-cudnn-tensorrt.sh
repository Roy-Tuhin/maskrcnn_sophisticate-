#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

source $LSCRIPTS/lscripts.config.sh

##----------------------------------------------------------
## Nvidia GPU Drivers
##----------------------------------------------------------

## Ubuntu 16.04 LTS
## Install in Virtual Console
if [[ $LINUX_VERSION == "16.04" ]]; then
  echo "...$LINUX_VERSION"
fi

# Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  echo $LINUX_VERSION
fi

# after successful Nvidia Driver installation

source $LINUX_SCRIPT_HOME/nvidia-driver-info.sh

# ##----------------------------------------------------------
# ## CUDA, cuDNN, TensorRT
# ##----------------------------------------------------------
source $LSCRIPTS/cuda.install.sh
source $LSCRIPTS/cudnn.install.sh
source $LSCRIPTS/tensorRT.install.sh
