#!/bin/bash

##----------------------------------------------------------
## Caffee
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/BVLC/caffe
#
## http://caffe.berkeleyvision.org/install_apt.html
## http://hanzratech.in/2015/07/27/installing-caffe-on-ubuntu.html
## https://gist.github.com/titipata/f0ef48ad2f0ebc07bcb9
#
##----------------------------------------------------------
## Installing pre-compiled Caffe
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [[ $LINUX_VERSION == "16.04" ]]; then
  echo "...$LINUX_VERSION"
  echo "Compile from source..."
  echo "Refer: http://caffe.berkeleyvision.org/install_apt.html"
else
  ## For Ubuntu (>= 17.04)
  NVIDIA_DRIVER_INSTALLED=$(prime-select query)
  if [ ! -z $NVIDIA_DRIVER_INSTALLED ] && [ $NVIDIA_DRIVER_INSTALLED == "nvidia" ]; then
    echo "### CUDA version"
    sudo -E apt -q -y purge caffe-cuda caffe-tools-cuda
    sudo -E apt -q -y install caffe-cuda
  else
    echo "### CPU Only"
    sudo -E apt -q -y install caffe-cpu
  fi
fi

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Installing pre-compiled Caffe
##----------------------------------------------------------

# ## Does not work with Python3
# Python 3.6.5 (default, Apr  1 2018, 05:46:30) 
# [GCC 7.3.0] on linux
# Type "help", "copyright", "credits" or "license" for more information.
# >>> import caffe
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
#   File "/home/alpha/Documents/ai-ml-dl/external/py-faster-rcnn/caffe-fast-rcnn/python/caffe/__init__.py", line 1, in <module>
#     from .pycaffe import Net, SGDSolver, NesterovSolver, AdaGradSolver, RMSPropSolver, AdaDeltaSolver, AdamSolver, NCCL, Timer
#   File "/home/alpha/Documents/ai-ml-dl/external/py-faster-rcnn/caffe-fast-rcnn/python/caffe/pycaffe.py", line 13, in <module>
#     from ._caffe import Net, SGDSolver, NesterovSolver, AdaGradSolver, \
# ImportError: dynamic module does not define module export function (PyInit__caffe)
# >>> 

# ##----------------------------------------------------------
