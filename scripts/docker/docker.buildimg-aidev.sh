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

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

function build_docker_img_aimldl() {
  source $SCRIPTS_DIR/docker.env-aidev.sh

  local CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/dockerfiles"

  echo "CONTEXT: $CONTEXT"
  echo "Building new image with TAG: ${TAG}"


  rm -rf ${CONTEXT}/config && \
    mkdir -p ${CONTEXT}/config

  cat > ${CONTEXT}/config/info.txt <<EOL
OS=${OS}
VERSION=${VERSION}
CUDA_VERSION=${CUDA_VERSION}
CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION}
nvidia_image_tag=${nvidia_image_tag}
VERSION=${VERSION}
BASE_IMAGE_NAME=${BASE_IMAGE_NAME}
TAG=${TAG}
pyVer=${pyVer}
timestamp=${timestamp}
PY_VENV_PATH=${PY_VENV_PATH}
PY_VENV_NAME=${PY_VENV_NAME}
DUSER=${DUSER}
BAZEL_VERSION=${BAZEL_VERSION}
WORK_BASE_PATH=${WORK_BASE_PATH}
OTHR_BASE_PATHS=${OTHR_BASE_PATHS}
DOCKER_BASEPATH=${DOCKER_BASEPATH}
MAINTAINER=${MAINTAINER}
EOL

  docker build \
    --build-arg "BASE_IMAGE_NAME=${BASE_IMAGE_NAME}" \
    --build-arg "pyVer=${pyVer}" \
    --build-arg "PY_VENV_PATH=${PY_VENV_PATH}" \
    --build-arg "PY_VENV_NAME=${PY_VENV_NAME}" \
    --build-arg "BAZEL_URL=${BAZEL_URL}" \
    --build-arg "duser=${DUSER}" \
    --build-arg "CUDA_VERSION=${CUDA_VERSION}" \
    --build-arg "CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION}" \
    --build-arg duser_grp=$(id -gn ${DUSER}) \
    --build-arg duser_id=$(id -u ${DUSER}) \
    --build-arg duser_grp_id=$(id -g ${DUSER}) \
    --build-arg "WORK_BASE_PATH=${WORK_BASE_PATH}" \
    --build-arg "OTHR_BASE_PATHS=${OTHR_BASE_PATHS}" \
    --build-arg "DOCKER_BASEPATH=${DOCKER_BASEPATH}" \
    --build-arg "MAINTAINER=${MAINTAINER}" \
    -t ${TAG} \
    -f ${DOCKERFILE} ${CONTEXT}
}

build_docker_img_aimldl
