#!/bin/bash

##----------------------------------------------------------
### Developer: Saqib Mobin
##----------------------------------------------------------

torchvision_dir="/codehub/external/vision"

git clone --recursive https://github.com/pytorch/vision.git ${torchvision_dir}

cd ${torchvision_dir}

## if you are updating an existing checkout
# git submodule sync
# git submodule update --init --recursive

python setup.py install

source ~/.bashrc