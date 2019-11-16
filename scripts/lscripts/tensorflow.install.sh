#!/bin/bash

##----------------------------------------------------------
### tensorflow - CPU, GPU builds
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## To be installed after python and pip
#
## https://www.tensorflow.org/install/install_linux
## https://www.tensorflow.org/install/install_sources
## https://gist.github.com/vbalnt/a0f789d788a99bfb62b61cb809246d64
## http://tflearn.org/installation/
## https://www.tensorflow.org/get_started/
#
##----------------------------------------------------------

# Pre-requisite - CUDA, cuDNN, python dependencies
# sudo apt install python-numpy python-dev python-pip python-wheel

#export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.11.0rc2-cp27-none-linux_x86_64.whl"

# Ubuntu/Linux 64-bit


## Check URL here
# https://www.tensorflow.org/install/install_linux#the_url_of_the_tensorflow_python_package


# Ubuntu/Linux 64-bit, GPU enabled, Python 2.7
# Requires CUDA toolkit 8.0 and CuDNN v5. For other versions, see "Installing from sources" below.
#export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.0.0rc2-cp27-none-linux_x86_64.whl"

# CPU only
##----------------------------------------------------------

# Python 2.7
##------------
## export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.0.0rc2-cp27-none-linux_x86_64.whl"
export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.9.0-cp27-none-linux_x86_64.whl"

# Python 3.5
##-------------
export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.9.0-cp35-cp35m-linux_x86_64.whl"

# Python 3.6
##-------------
export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.9.0-cp36-cp36m-linux_x86_64.whl"


# GPU
##----------------------------------------------------------
# Python 2.7
##------------
export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.9.0-cp27-none-linux_x86_64.whl"

# Python 3.5
##-------------
export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.9.0-cp35-cp35m-linux_x86_64.whl"

# Python 3.6
##-------------
export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.9.0-cp36-cp36m-linux_x86_64.whl"


#https://medium.com/@acrosson/installing-nvidia-cuda-cudnn-tensorflow-and-keras-69bbf33dce8a
#https://github.com/dusty-nv/jetson-inference

#https://devblogs.nvidia.com/parallelforall/deploying-deep-learning-nvidia-tensorrt/

## From previous build from sources on other machine
# cd $HOME/softwares/tensorflow-1.7.0/tensorflow_pkg
# sudo pip install tensorflow-1.7.0-cp27-cp27mu-linux_x86_64.whl



## pip install 
## https://www.tensorflow.org/install/pip
## cpu
pip install tensorflow
## gpu
pip install tensorflow-gpu



sudo pip search tensorflow


sudo pip install --upgrade $TF_BINARY_URL
sudo pip install $TF_BINARY_URL

# to download
sudo pip install -d $HOME/Downloads/pip-cache $TF_BINARY_URL
sudo pip3 install -d $HOME/Downloads/pip-cache $TF_BINARY_URL

sudo pip2 install --cache-dir $HOME/softwares/pip-cache tensorflow-gpu

#pip install tensorflow-gpu #GPU
pip install tensorflow  #CPU only

python -c "import tensorflow as tf; print(tf.__version__)"



git clone https://github.com/tensorflow/tensorflow
cd tensorflow
git checkout v1.10.0-rc1

#NVIDIA® Collective Communications Library ™ (NCCL) (pronounced “Nickel”
#https://docs.nvidia.com/deeplearning/sdk/nccl-install-guide/index.html

# Install the repository.
# For the local NCCL repository:
sudo dpkg -i nccl-repo-<version>.deb
# For the network repository:
sudo dpkg -i nvidia-machine-learning-repo-<version>.deb
# Update the APT database:
sudo apt update
# Install the libnccl2 package with APT. Additionally, if you need to compile applications with NCCL, you can install the libnccl-dev package as well:
# Note: If you are using the network repository, the following command will upgrade CUDA to the latest version.
sudo apt install libnccl2 libnccl-dev
# If you prefer to keep an older version of CUDA, specify a specific version, for example:
sudo apt-get install libnccl2=2.0.0-1+cuda8.0 libnccl-dev=2.0.0-1+cuda8.0


# https://developer.nvidia.com/nccl/nccl-download  



# - Uninstall CUDA 9.1 and Install CUDA 9.0
## Re-installing different CUDA version
## Uninstall CUDA dependent libs
#
sudo apt purge -y caffe-cuda caffe-tools-cuda
sudo apt purge -y libnccl2 libnccl-dev
sudo apt autoremove
#
sudo apt purge -y nv-tensorrt-repo-ubuntu1604-cuda9.0-rc-trt4.0.0.3-20180329
#
sudo apt purge -y libcudnn7 libcudnn7-dev libcudnn7-doc
#
sudo apt purge -y cuda-*
## dpkg: warning: while removing cuda-samples-9-1, directory '/usr/local/cuda-9.1/samples/1_Utilities/deviceQuery' not empty so not removed
## dpkg: warning: while removing cuda-license-9-1, directory '/usr/local/cuda-9.1' not empty so not removed
sudo rm -rf /usr/local/cuda-9.1
