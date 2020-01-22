#!/bin/bash

## ----------------------------------------
## Building Nvidia CUDA Docker Images from source
## ----------------------------------------

function docker_buildimg_cuda() {
  local BUILD_FOR_CUDA_VER="10.0"

  if [ ! -z $1 ];then
    local BUILD_FOR_CUDA_VER=$1
  fi

  if [[ ${BUILD_FOR_CUDA_VER} == "9.0" ]]; then
    export IMAGE_NAME="nvidia/cuda"
    export OS="ubuntu16.04"
    export CUDA_VERSION="9.0"
    local CUDNN_VERSION="7.6.4.38"
    local CUDNN_MAJOR_VERSION=7
  elif [[ ${BUILD_FOR_CUDA_VER} == "10.0" ]]; then
    export IMAGE_NAME="nvidia/cuda"
    export OS="ubuntu18.04"
    export CUDA_VERSION="10.0"
    local CUDNN_VERSION="7.6.4.38"
    local CUDNN_MAJOR_VERSION=7
  else
    echo "Unsupported CUDA version: ${BUILD_FOR_CUDA_VER}"
    return
  fi

  local DOCKERFILE_BASEPATH="dockerfiles/cuda/dist/"

  ## build base, runtime and devel
  docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" "${DOCKERFILE_BASEPATH}/${OS}/${CUDA_VERSION}/base"
  docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/${OS}/${CUDA_VERSION}/runtime"
  docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/${OS}/${CUDA_VERSION}/devel"

  local NVIDIA_IMAGE_TAG="${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}"
  docker tag "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" "${NVIDIA_IMAGE_TAG}"

  # docker run --gpus all 8877932d6c3e nvidia-smi
}

docker_buildimg_cuda $1
