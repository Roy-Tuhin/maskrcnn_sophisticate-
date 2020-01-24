#!/bin/bash

function cuda_install_dockerfile() {
  sudo apt -s purge 'cuda*'
  sudo apt -s purge 'cudnn*'

  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  gnupg2 curl ca-certificates && \
      curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | sudo apt-key add - && \
      echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
      echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list

  local CUDA_VER="10.0"
  local CUDA_PKG="${CUDA_VER}.130-1"
  local CUDA_REL=$(echo ${CUDA_VER} | tr . -) ## 10-0
  local CUDA_VERSION=${CUDA_VER}
  local CUDA_PKG_VERSION="${CUDA_REL}=${CUDA_PKG}"

  local cuDNN_VER=7
  local CUDNN_MAJOR_VERSION=${cuDNN_VER}
  local CUDNN_VERSION=7.6.4.38

  local NCCL_VERSION=2.4.8

  local TENSORRT_VER=5
  local LIBNVINFER_VER=5.1.5-1+cuda${CUDA_VER}

  # For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
          cuda-cudart-${CUDA_PKG_VERSION} \
  cuda-compat-${CUDA_VER}

  sudo ln -s cuda-${CUDA_VER} /usr/local/cuda

  # Required for nvidia-docker v1
  sudo echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
      sudo echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

  export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH
  export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH

  # nvidia-container-runtime
  export NVIDIA_VISIBLE_DEVICES=all
  export NVIDIA_DRIVER_CAPABILITIES=compute,utility
  export NVIDIA_REQUIRE_CUDA="cuda>=${CUDA_VER} brand=tesla,driver>=384,driver<385 brand=tesla,driver>=410,driver<411"

  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
      cuda-libraries-${CUDA_PKG_VERSION} \
  cuda-nvtx-${CUDA_PKG_VERSION} \
  libnccl2=$NCCL_VERSION-1+cuda${CUDA_VER} && \
      sudo apt-mark hold libnccl2

  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
      libcudnn7=$CUDNN_VERSION-1+cuda${CUDA_VER}

  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
          cuda-nvml-dev-${CUDA_PKG_VERSION} \
          cuda-command-line-tools-${CUDA_PKG_VERSION} \
  cuda-libraries-dev-${CUDA_PKG_VERSION} \
          cuda-minimal-build-${CUDA_PKG_VERSION} \
          libnccl-dev=$NCCL_VERSION-1+cuda${CUDA_VER}

  export LIBRARY_PATH=/usr/local/cuda/lib64/stubs:$LIBRARY_PATH

  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
      libcudnn7=$CUDNN_VERSION-1+cuda${CUDA_VER} \
  libcudnn7-dev=$CUDNN_VERSION-1+cuda${CUDA_VER}


  ## Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
  ## dynamic linker run-time bindings
  sudo ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
  sudo echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf
  sudo ldconfig

  sudo apt-get install -y --no-install-recommends \
      libnvinfer${TENSORRT_VER}=${LIBNVINFER_VER} \
      libnvinfer-dev=${LIBNVINFER_VER}

  ## Tensorflow specific configuration
  ## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile
  # Configure the build for our CUDA configuration.
  export CI_BUILD_PYTHON=3
  export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
  export TF_NEED_CUDA=1
  export TF_NEED_TENSORRT=1
  export TF_CUDA_COMPUTE_CAPABILITIES=3.5,5.2,6.0,6.1,7.0
  export TF_CUDA_VERSION=${CUDA_VERSION}
  export TF_CUDNN_VERSION=${CUDNN_MAJOR_VERSION}

  export DEBIAN_FRONTEND=noninteractive
  export FORCE_CUDA="1"
  export TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"

}

cuda_install_dockerfile

