local OS="ubuntu18.04"

##----------------------------------------------------------
## CUDA
## https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/
##----------------------------------------------------------
# local CUDA_VER="10.0"
# local CUDA_PKG="${CUDA_VER}.130-1"
# local CUDA_REL=$(echo ${CUDA_VER} | tr . -) ## 10-0
# local CUDA_VERSION=${CUDA_VER}
# local CUDA_PKG_VERSION="${CUDA_REL}=${CUDA_PKG}"

## https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-10-2_10.2.89-1_amd64.deb
local CUDA_VER="10.2"
local CUDA_PKG="${CUDA_VER}.89-1"
local CUDA_REL=$(echo ${CUDA_VER} | tr . -) ## 10-2
local CUDA_VERSION=${CUDA_VER}
local CUDA_PKG_VERSION="${CUDA_REL}=${CUDA_PKG}"

##----------------------------------------------------------
## cuDNN
## https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/
##----------------------------------------------------------
local cuDNN_VER="7"
local CUDNN_VERSION="7.6.5.32"
local CUDA_REL="7.6.5.32-1"
local cuDNN_RELEASE=${CUDA_REL}
local CUDNN_MAJOR_VERSION=${cuDNN_VER}
#
local cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
local cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
local cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"

##----------------------------------------------------------
## TensorRT
## https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/
##----------------------------------------------------------

local TENSORRT_VER=6
local TENSORRT_VERSION=${TENSORRT_VER}
local LIBNVINFER_VER=6.0.1-1+cuda${CUDA_VER}

##----------------------------------------------------------
## AI Frameworks
##----------------------------------------------------------

## for tensorflow till 1.13.1 release
local TF_VER="1.13.1"
local TENSORFLOW_VER=${TF_VER}
# local TF_VERSION=${TENSORFLOW_VER}
local TF_RELEASE="v${TF_VER}"
local TF_BAZEL_VER="0.21.0"
# local TF_BAZEL_VER="1.1.0"

## compatible with TF 1.13.1
local KERAS_VER="2.2.3"
##-------

# ## for tensorflow till 1.15 release
# local TF_VER="1.15.0"
# local TF_VERSION=${TENSORFLOW_VER}
# local TF_RELEASE="v${TF_VER}"
# local TF_BAZEL_VER="0.24.1" ## min
# local TF_BAZEL_VER="0.26.1" ## max
# ##-------

local PYTORCH_VER="1.1.0"

##-------

local BAZEL_VER=${TF_BAZEL_VER}
local BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh"
