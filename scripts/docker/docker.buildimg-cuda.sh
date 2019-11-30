#!/bin/bash

# export IMAGE_NAME="nvidia/cuda"
# export OS="ubuntu18.04"
# export CUDA_VERSION="10.0"
# CUDNN_VERSION="7.6.4.38"
# CUDNN_MAJOR_VERSION=7

## ----------------------------------------

export IMAGE_NAME="nvidia/cuda"
export OS="ubuntu16.04"
export CUDA_VERSION="9.0"
CUDNN_VERSION="7.6.4.38"
CUDNN_MAJOR_VERSION=7

DOCKERFILE_BASEPATH="dockerfiles/cuda/dist/"

docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" "${DOCKERFILE_BASEPATH}/${OS}/${CUDA_VERSION}/base"
docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/${OS}/${CUDA_VERSION}/runtime"
docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "${DOCKERFILE_BASEPATH}/${OS}/${CUDA_VERSION}/devel"

NVIDIA_IMAGE_TAG="${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}"
docker tag "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" "${NVIDIA_IMAGE_TAG}"

# docker run --gpus all 8877932d6c3e nvidia-smi
