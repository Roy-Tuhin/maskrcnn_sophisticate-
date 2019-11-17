#/bin/bash

export IMAGE_NAME="nvidia/cuda"

export OS="ubuntu16.04"
export CUDA_VERSION="9.0"


# export OS="ubuntu18.04"
# export CUDA_VERSION="10.0"
# export CUDNN_VERSION="7.6.4.38"

docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" "dist/${OS}/${CUDA_VERSION}/base"
# docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "dist/${OS}/${CUDA_VERSION}/runtime"
# docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "dist/${OS}/${CUDA_VERSION}/devel"

# docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "dist/${OS}/${CUDA_VERSION}/devel/cudnn7"


## https://hub.docker.com/r/nvidia/cuda
