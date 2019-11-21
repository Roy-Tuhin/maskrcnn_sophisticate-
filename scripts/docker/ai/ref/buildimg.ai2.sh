#/bin/bash


# Usage:
# source docker.buildimg.mongodb-userfix <docker-file-name> <docker-image-tag>

function build_docker_img_aidev() {
  ## References:
  ## https://linuxize.com/post/how-to-build-docker-images-with-dockerfile/
  ## https://hub.docker.com/r/nvidia/cuda


  # local CUDA_VERSION="10.0"
  # local CUDNN_VERSION="7.6.4.38"
  # local OS="ubuntu18.04"
  # local TAG=${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}

  WHICHONE="aidev"
  # TAG="mangalbhaskar/aimldl:${WHICHONE}-2"
  # DOCKERFILE="${WHICHONE}/Dockerfile"

  ## test1
  local BASE_IMAGE_NAME="nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04"
  local TAG="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-py3-venv"
  local DOCKERFILE="${WHICHONE}/Dockerfile_test1"
  local DOCKERFILE="${WHICHONE}/Dockerfile_test3"

  ## test2
  local BASE_IMAGE_NAME="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-py3-venv"
  local TAG="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-py3-venv2"
  local DOCKERFILE="${WHICHONE}/Dockerfile_test2"

  ## test4
  local BASE_IMAGE_NAME="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-py3-venv2"
  local TAG="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-py3-venv3b"
  local DOCKERFILE="${WHICHONE}/Dockerfile_test4"


  local CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/${WHICHONE}"
  echo "CONTEXT: $CONTEXT"

  local pyVer=3
  # local timestamp=$(date +%Y-%m-%d)
  local timestamp=$(date +%Y%m%d_%H%M)
  local PY_VENV_PATH="/virtualmachines/virtualenvs"
  local PY_VENV_NAME=py_${pyVer}_${timestamp}
  local DUSER=${USER}

  local BAZEL_VERSION=1.1.0
  local BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"

  echo "Built new image ${TAG}"


  docker build \
    --build-arg "BASE_IMAGE_NAME=${BASE_IMAGE_NAME}" \
    --build-arg "pyVer=${pyVer}" \
    --build-arg "PY_VENV_PATH=${PY_VENV_PATH}" \
    --build-arg "PY_VENV_NAME=${PY_VENV_NAME}" \
    --build-arg "BAZEL_URL=${BAZEL_URL}" \
    --build-arg duser=$DUSER \
    --build-arg duser_grp=$(id -gn $DUSER) \
    --build-arg duser_id=$(id -u $DUSER) \
    --build-arg duser_grp_id=$(id -g $DUSER) \
    -t ${TAG} \
    -f ${DOCKERFILE} ${CONTEXT}

}

build_docker_img_aidev