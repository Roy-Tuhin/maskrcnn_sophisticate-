#/bin/bash


# WHICHONE="aidev"
# IMAGE_NAME="aimldl"
# CUDA_VERSION="10.0"
# CUDNN_VERSION="7.6.4.38"
# OS="ubuntu18.04"
TAG=${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}

WHICHONE="redis"
TAG=${WHICHONE}

DOCKERFILE="${WHICHONE}/Dockerfile"
CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/${WHICHONE}"

docker build \
  --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
  -t  ${TAG} \
  -f ${DOCKERFILE} ${CONTEXT}

## https://linuxize.com/post/how-to-build-docker-images-with-dockerfile/
## https://hub.docker.com/r/nvidia/cuda