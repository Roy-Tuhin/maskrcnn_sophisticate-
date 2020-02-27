#!/bin/bash

## Download and install anaconda
user=$(whoami)
dir="/home/${user}/Downloads"
url="https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh"
filename=$(echo ${url} | cut -d "/" -f 5)


echo wget ${url} -P ${dir}
wget ${url} -P ${dir}

echo source ${dir}/${filename}
source ${dir}/${filename}

##PyTorch dependencies

conda install numpy ninja pyyaml mkl mkl-include setuptools cmake cffi
conda install -c pytorch magma-cuda101 # or [magma-cuda92 | magma-cuda100 | magma-cuda101 ] depending on your cuda version

git clone --recursive https://github.com/pytorch/pytorch /codehub/external

cd /codehub/external/pytorch

## if you are updating an existing checkout
# git submodule sync
# git submodule update --init --recursive

export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}

## Specify TORCH_CUDA_ARCH_LIST based on compute capability of GPU. Can be found in deviceQuery in cuda samples.
TORCH_CUDA_ARCH_LIST="3.5" python setup.py install