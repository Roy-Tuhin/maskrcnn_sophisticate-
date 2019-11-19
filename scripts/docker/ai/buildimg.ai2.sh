#/bin/bash

# WHICHONE="aidev"
# IMAGE_NAME="aimldl"
# CUDA_VERSION="10.0"
# CUDNN_VERSION="7.6.4.38"
# OS="ubuntu18.04"
# TAG=${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}

WHICHONE="aidev"
TAG="mangalbhaskar/aimldl:${WHICHONE}"

DOCKERFILE="${WHICHONE}/Dockerfile"
CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/${WHICHONE}"
pyVer=3
PY_VENV_PATH="/virtualmachines/virtualenvs"
DUSER=${USER}

docker build \
  --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
  --build-arg "pyVer=${pyVer}" \
  --build-arg "PY_VENV_PATH=${PY_VENV_PATH}" \
  --build-arg duser=$DUSER \
  --build-arg duser_grp=$(id -gn $DUSER) \
  --build-arg duser_id=$(id -u $DUSER) \
  --build-arg duser_grp_id=$(id -g $DUSER) \
  -t ${TAG} \
  -f ${DOCKERFILE} ${CONTEXT}

## https://linuxize.com/post/how-to-build-docker-images-with-dockerfile/
## https://hub.docker.com/r/nvidia/cuda