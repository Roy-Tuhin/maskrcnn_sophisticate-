# OS="ubuntu18.04"
# CUDA_VERSION=10.0
# CUDNN_VERSION="7.6.4.38"
# CUDNN_MAJOR_VERSION=7
# TENSORRT_VERSION=5

OS="ubuntu18.04"

##----------------------------------------------------------
## CUDA
##----------------------------------------------------------
CUDA_VER="10.0"
CUDA_REL="10-0" # echo $CUDA_VER | tr . -
CUDA_OS_REL="1804"
CUDA_RELEASE="local-${CUDA_VER}.130-410.48_1.0-1_amd64"
#CUDA_PCKG="cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb"
CUDA_PCKG="cuda-repo-ubuntu${CUDA_OS_REL}-${CUDA_REL}-${CUDA_RELEASE}.deb"
# CUDA_REPO_KEY="10-0-local-10.0.130-410.48"
CUDA_REPO_KEY="${CUDA_REL}-local-${CUDA_VER}.130-410.48/7fa2af80.pub"

CUDA_URL="https://developer.download.nvidia.com/compute/cuda/${CUDA_VER}/secure/Prod/local_installers/${CUDA_PCKG}"
CUDA_VERSION=${CUDA_VER}


##----------------------------------------------------------
## cuDNN
##----------------------------------------------------------
cuDNN_VER="7"
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu.Dockerfile
# cuDNN_RELEASE="7.6.2.24-1"
# CUDNN_VERSION="7.6.2.24-1"

cuDNN_RELEASE="7.6.4.38"
CUDNN_VERSION="7.6.4.38"
cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
CUDNN_MAJOR_VERSION=${cuDNN_VER}


##----------------------------------------------------------
## TensorRT
## https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html
## https://devtalk.nvidia.com/default/topic/1050672/how-to-install-tensort-in-docker-on-a-cuda-10-1-host-/?offset=4
##----------------------------------------------------------

TENSORRT_VER=5
TENSORRT_VERSION=${TENSORRT_VER}
TENSORRT_RELEASE="trt5.1.5.0-ga-20190427_1-1_amd64"
TENSORRT_OS_REL="1804"
# tensorRTFILE="nv-tensorrt-repo-ubuntu1804-cuda10.0-trt5.1.5.0-ga-20190427_1-1_amd64.deb"
tensorRTFILE="nv-tensorrt-repo-ubuntu${TENSORRT_OS_REL}-cuda${CUDA_VER}-${TENSORRT_RELEASE}.deb"
TENSORRT_PCKG=${tensorRTFILE}
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu.Dockerfile
## 5.1.5-1+cuda10.0
LIBNVINFER_VER=5.1.5-1+cuda${CUDA_VER}

##----------------------------------------------------------
## AI Frameworks
##----------------------------------------------------------

## for tensorflow till 1.13.1 release
TF_VER="1.13.1"
TENSORFLOW_VER=${TF_VER}
# TF_VERSION=${TENSORFLOW_VER}
TF_RELEASE="v${TF_VER}"
TF_BAZEL_VER="0.21.0"

## compatible with TF 1.13.1
KERAS_VER="2.2.3"
##-------

# ## for tensorflow till 1.15 release
# TF_VER="1.15.0"
# TF_VERSION=${TENSORFLOW_VER}
# TF_RELEASE="v${TF_VER}"
# TF_BAZEL_VER="0.24.1" ## min
# TF_BAZEL_VER="0.26.1" ## max
# ##-------

PYTORCH_VER="1.1.0"

##-------

BAZEL_VER=${TF_BAZEL_VER}
BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh"
