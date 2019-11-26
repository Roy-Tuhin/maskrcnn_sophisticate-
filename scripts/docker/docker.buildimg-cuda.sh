#!/bin/bash

export IMAGE_NAME="nvidia/cuda"
export CUDA_VERSION="9.0"
export OS="ubuntu16.04"

# docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" "cuda/${OS}/${CUDA_VERSION}/base"
# docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "cuda/${OS}/${CUDA_VERSION}/runtime"
docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "cuda/${OS}/${CUDA_VERSION}/devel"

# docker run --gpus all 8877932d6c3e nvidia-smi
