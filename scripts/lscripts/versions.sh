#!/bin/bash

##----------------------------------------------------------
### version - version variables for the installed softwares
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## last one is what is used if not commented#
##----------------------------------------------------------

## Nvidia GPU setup
NVIDIA_DRIVER_VER='387.22'
NVIDIA_DRIVER_VER='390.42'

## CUDA
## CUDA 9.0 has better support and release cycle compared to 9.1
CUDA_VER="9.0"
CUDA_REL="9-0" # echo $CUDA_VER | tr . -
CUDA_OS_REL="1604"
# CUDA_PCKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64.deb"
CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_$CUDA_VER.176-1_amd64.deb"
CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/$CUDA_PCKG"

# CUDA_VER="9.1"
# CUDA_REL="9-1" # echo $CUDA_VER | tr . -
# CUDA_OS_REL="1604"
# CUDA_PCKG="cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64.deb"
# CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_$CUDA_VER.85-1_amd64.deb"
# CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/$CUDA_PCKG"

# CUDA_VER="9.2"
# CUDA_REL="9-2" # echo $CUDA_VER | tr . -
# CUDA_OS_REL="1710"
# CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_CUDA_VER.148-1_amd64.deb"
# CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/$CUDA_PCKG"

CUDA_VER="10.0"
CUDA_REL="10-0" # echo $CUDA_VER | tr . -
CUDA_OS_REL="1804"
# CUDA_PCKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64.deb"
CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_$CUDA_VER.176-1_amd64.deb"
CUDA_PCKG="cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb"
# CUDA_PCKG="cuda_10.0.130_410.48_linux.run"
# CUDA_URL="https://developer.download.nvidia.com/compute/cuda/10.0/secure/Prod/local_installers/cuda_10.0.130_410.48_linux.run"
CUDA_URL="https://developer.download.nvidia.com/compute/cuda/10.0/secure/Prod/local_installers/$CUDA_PCKG"

## cuDNN
cuDNN_VER="7"
cuDNN_RELEASE="7.1.4.18-1"
cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"

cuDNN_VER="7"
cuDNN_RELEASE="7.6.0.64-1"
cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"

# https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/Ubuntu18_04-x64/libcudnn7-dev_7.5.0.56-1%2Bcuda10.0_amd64.deb
# https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/Ubuntu18_04-x64/libcudnn7-doc_7.5.0.56-1%2Bcuda10.0_amd64.deb
# https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/Ubuntu18_04-x64/libcudnn7_7.5.0.56-1%2Bcuda10.0_amd64.deb

# https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/cudnn-10.0-linux-x64-v7.5.0.56.tgz


## TensorRT for CUDA 9.0
tensorRTFILE="nv-tensorrt-repo-ubuntu1604-cuda9.0-rc-trt4.0.0.3-20180329_1-1_amd64.deb"

## TensorRT for CUDA 10.0
tensorRTFILE="nv-tensorrt-repo-ubuntu1804-cuda10.0-trt5.1.5.0-ga-20190427_1-1_amd64.deb"

##----------------------------------------------------------

## PHP version
PHP_VER="7.0"
PHP_VER="7.1"
PHP_VER="7.2"
#
## Node JS version
NODEJS_VER=7
NODEJS_VER=8
NODEJS_VER=9
#
## JAVA JDK version
JAVA_JDK_VER="8"
#JAVA_JDK_VER="9"
#
SUITE_PARSE_VER="5.3.0"
#
CERES_SOLVER_REL="-1.10.0"
CERES_SOLVER_REL_TAG="1.10.0"
#---
CERES_SOLVER_REL="-1.14.0"
CERES_SOLVER_REL_TAG="1.14.0"
#
## GIS
PROJ_VER="4.9.3"
TIFF_VER="4.0.8"
# TIFF_VER="4.0.9"
GEOTIFF_VER="1.4.2"
#
GEOS_VER="3.6.1"
GEOS_VER="3.6.3"
#
BOOST_VER="1.64.0"
#BOOST_VER="1.67.0"
#
EIGEN_REL_TAG="3.3.5"
#
MPIR_REL_TAG="mpir-3.0.0"
#
LAZ_PERF_REL_TAG="1.3.0"
# git clone is working now and that is used in script
LIBKML_VER="1.2.0"
LIBKML_VER="1.3.0"
#
# git clone is used, mentioned here as alternative
LASZIP_VER="2.2.0"
LASZIP_VER="3.2.2"
#
GEOWAVE_REL_TAG="v0.9.7"
#
GDAL_VER="2.2.4"
#
PDAL_VER="1.7"
PDAL_BUILD="1"
PDAL_RELEASE="$PDAL_VER.$PDAL_BUILD"
##
VTK_VER="7.1"
VTK_BUILD="1"
VTK_RELEASE="$VTK_VER.$VTK_BUILD"

VTK_VER="8.1"
VTK_BUILD="0"
VTK_RELEASE="$VTK_VER.$VTK_BUILD"
#
OpenCV_VER_CHECKOUT="3.3.0"
OpenCV_VER_CHECKOUT="3.4.1"
OpenCV_VER_CHECKOUT="3.4.2"
#
HAROOPAD_VER="0.13.1"
#
MAGMA_VER="2.5.0-rc1"
