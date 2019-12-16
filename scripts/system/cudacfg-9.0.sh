# OS="ubuntu16.04"
# CUDA_VERSION=9.0
# CUDNN_VERSION="7.6.4.38"
# CUDNN_MAJOR_VERSION=7
# TENSORRT_VERSION=4

OS="ubuntu16.04"

##----------------------------------------------------------
## CUDA
##----------------------------------------------------------
CUDA_VER="9.0"
CUDA_REL="9-0" # echo $CUDA_VER | tr . -
CUDA_OS_REL="1604"
CUDA_RELEASE="local_${CUDA_VER}.176-1_amd64"
# CUDA_PCKG="cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64.deb"
CUDA_PCKG="cuda-repo-ubuntu${CUDA_OS_REL}-${CUDA_REL}-${CUDA_RELEASE}.deb"
# CUDA_REPO_KEY="${CUDA_REL}-local"
#
CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu${CUDA_OS_REL}/x86_64/${CUDA_PCKG}"
CUDA_VERSION=${CUDA_VER}


##----------------------------------------------------------
## cuDNN
##----------------------------------------------------------
cuDNN_VER="7"

## refer Nvidia cuDNN dockerfile for cuda 9.0
# cuDNN_RELEASE="7.1.4.18-1"
# CUDNN_VERSION="7.1.4.18-1"

cuDNN_RELEASE="7.6.4.38"
CUDNN_VERSION="7.6.4.38"
#
#
cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
CUDNN_MAJOR_VERSION=${cuDNN_VER}

##----------------------------------------------------------
## TensorRT
## https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html
## https://devtalk.nvidia.com/default/topic/1050672/how-to-install-tensort-in-docker-on-a-cuda-10-1-host-/?offset=4
##----------------------------------------------------------
TENSORRT_VER=4
# TENSORRT_VERSION=${TENSORRT_VER}
TENSORRT_RELEASE="rc-trt4.0.0.3-20180329_1-1_amd64"
TENSORRT_OS_REL="1604"
# tensorRTFILE="nv-tensorrt-repo-ubuntu1604-cuda9.0-rc-trt4.0.0.3-20180329_1-1_amd64.deb"
tensorRTFILE="nv-tensorrt-repo-ubuntu${TENSORRT_OS_REL}-cuda${CUDA_VER}-${TENSORRT_RELEASE}.deb"
TENSORRT_PCKG=${tensorRTFILE}

## based on already installed system with cuda 9.0
## 4.1.0-1+cuda9.0
LIBNVINFER_VER=4.1.0-1+cuda${CUDA_VER}

##----------------------------------------------------------
## AI Frameworks
##----------------------------------------------------------

TF_VER="1.9.0"
TENSORFLOW_VER=${TF_VER}
# TF_VERSION=${TENSORFLOW_VER}
TF_BAZEL_VER="0.5.0" ## TODO

KERAS_VER="2.2.2"

PYTORCH_VER="0.4.0"

## bazel configuration for compiling tensorflow from source
BAZEL_VER=${TF_BAZEL_VER}
BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh"
