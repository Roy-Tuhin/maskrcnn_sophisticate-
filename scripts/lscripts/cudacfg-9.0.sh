# local OS="ubuntu16.04"
# local CUDA_VERSION=9.0
# local CUDNN_VERSION="7.6.4.38"
# local CUDNN_MAJOR_VERSION=7
# local TENSORRT_VERSION=4

local OS="ubuntu16.04"

##----------------------------------------------------------
## CUDA
##----------------------------------------------------------
local CUDA_VER="9.0"
local CUDA_REL="9-0" # echo $CUDA_VER | tr . -
local CUDA_OS_REL="1604"
local CUDA_RELEASE="local_${CUDA_VER}.176-1_amd64"
# local CUDA_PCKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64.deb"
local CUDA_PCKG="cuda-repo-ubuntu${CUDA_OS_REL}-${CUDA_REL}-${CUDA_RELEASE}.deb"
# local CUDA_REPO_KEY="${CUDA_REL}-local"
#
local CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu${CUDA_OS_REL}/x86_64/${CUDA_PCKG}"
local CUDA_VERSION=${CUDA_VER}


##----------------------------------------------------------
## cuDNN
##----------------------------------------------------------
local cuDNN_VER="7"

## refer Nvidia cuDNN dockerfile for cuda 9.0
# local cuDNN_RELEASE="7.1.4.18-1"
# local CUDNN_VERSION="7.1.4.18-1"

local cuDNN_RELEASE="7.6.4.38"
local CUDNN_VERSION="7.6.4.38"
#
#
local cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
local cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
local cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
local CUDNN_MAJOR_VERSION=${cuDNN_VER}

##----------------------------------------------------------
## TensorRT
## https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html
## https://devtalk.nvidia.com/default/topic/1050672/how-to-install-tensort-in-docker-on-a-cuda-10-1-host-/?offset=4
##----------------------------------------------------------
local TENSORRT_VER=4
# local TENSORRT_VERSION=${TENSORRT_VER}
local TENSORRT_RELEASE="rc-trt4.0.0.3-20180329_1-1_amd64"
local TENSORRT_OS_REL="1604"
# local tensorRTFILE="nv-tensorrt-repo-ubuntu1604-cuda9.0-rc-trt4.0.0.3-20180329_1-1_amd64.deb"
local tensorRTFILE="nv-tensorrt-repo-ubuntu${TENSORRT_OS_REL}-cuda${CUDA_VER}-${TENSORRT_RELEASE}.deb"
local TENSORRT_PCKG=${tensorRTFILE}

## based on already installed system with cuda 9.0
## 4.1.0-1+cuda9.0
local LIBNVINFER_VER=4.1.0-1+cuda${CUDA_VER}

##----------------------------------------------------------
## AI Frameworks
##----------------------------------------------------------

local TF_VER="1.9.0"
local TENSORFLOW_VER=${TF_VER}
# local TF_VERSION=${TENSORFLOW_VER}
local TF_BAZEL_VER="0.5.0" ## TODO

local KERAS_VER="2.2.2"

local PYTORCH_VER="0.4.0"

## bazel configuration for compiling tensorflow from source
local BAZEL_VER=${TF_BAZEL_VER}
local BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh"
