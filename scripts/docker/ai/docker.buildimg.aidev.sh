#/bin/bash

## References:
## https://linuxize.com/post/how-to-build-docker-images-with-dockerfile/
## https://hub.docker.com/r/nvidia/cuda
## https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/tools/dockerfiles/bashrc
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile
## https://blog.hasura.io/how-to-write-dockerfiles-for-python-web-apps-6d173842ae1d/
## https://stackoverflow.com/questions/34213837/dockerfile-output-of-run-instruction-into-a-variable
## https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work
## https://stackoverflow.com/questions/34911622/dockerfile-set-env-to-result-of-command
## https://unix.stackexchange.com/questions/117467/how-to-permanently-set-environmental-variables
## https://github.com/moby/moby/issues/29110

# ERROR: locustio 0.13.2 has requirement gevent==1.5a2, but you'll have gevent 1.4.0 which is incompatible.


## quick image test
## docker run --name aidev-3a --gpus all --rm -it mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-3 bash


function build_docker_img_aimldl() {
  local WHICHONE="aidev"
  local OS="ubuntu18.04"
  local CUDA_VERSION=10.0
  local CUDNN_VERSION="7.6.4.38"
  local CUDNN_MAJOR_VERSION=7
  local nvidia_image_tag=${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}


  local NEW_IMAGE_VERSION=3
  local BASE_IMAGE_NAME="nvidia/cuda:${nvidia_image_tag}"
  local TAG="mangalbhaskar/aimldl:${nvidia_image_tag}-aidev-${NEW_IMAGE_VERSION}"

  local DOCKERFILE="${WHICHONE}/Dockerfile"

  local CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/${WHICHONE}"
  echo "CONTEXT: $CONTEXT"

  local pyVer=3
  local timestamp=$(date +%Y%m%d_%H%M)
  local PY_VENV_PATH="/virtualmachines/virtualenvs"
  local PY_VENV_NAME=py_${pyVer}_${timestamp}
  local DUSER=${USER}

  local BAZEL_VERSION=1.1.0
  local BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"

  echo "Building new image with TAG: ${TAG}"

  docker build \
    --build-arg "BASE_IMAGE_NAME=${BASE_IMAGE_NAME}" \
    --build-arg "pyVer=${pyVer}" \
    --build-arg "PY_VENV_PATH=${PY_VENV_PATH}" \
    --build-arg "PY_VENV_NAME=${PY_VENV_NAME}" \
    --build-arg "BAZEL_URL=${BAZEL_URL}" \
    --build-arg duser=$DUSER \
    --build-arg CUDA_VERSION=${CUDA_VERSION} \
    --build-arg CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION} \
    --build-arg duser_grp=$(id -gn $DUSER) \
    --build-arg duser_id=$(id -u $DUSER) \
    --build-arg duser_grp_id=$(id -g $DUSER) \
    -t ${TAG} \
    -f ${DOCKERFILE} ${CONTEXT}
}

build_docker_img_aimldl
