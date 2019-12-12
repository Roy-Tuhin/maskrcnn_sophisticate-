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


## Usage
# source docker.buildimg-aidev.sh 1>$(pwd)/buildinfo/buildimg-$(date -d now +'%d%m%y_%H%M%S').log 2>&1

function build_docker_img_aimldl() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

  source ${SCRIPTS_DIR}/docker.config.sh $1

  ${DOCKER_CMD} --version

  local CONTEXT="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/dockerfiles"

  echo "CONTEXT: $CONTEXT"
  echo "Building new image with TAG: ${TAG}"

  mkdir -p ${CONTEXT}/config && \
    mv ${CONTEXT}/config/* ${SCRIPTS_DIR}/buildinfo/

  local build_info_file=${CONTEXT}/config/${WHICHONE}-${timestamp}.info
  echo "build_info_file: ${build_info_file}"
  cat > ${build_info_file} <<EOL
OS=${OS}
VERSION=${VERSION}
CUDA_VERSION=${CUDA_VERSION}
CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION}
cuDNN_RELEASE=${cuDNN_RELEASE}
TENSORRT_VER=${TENSORRT_VER}
LIBNVINFER_VER=${LIBNVINFER_VER}
TENSORFLOW_VER=${TENSORFLOW_VER}
BAZEL_VER=${BAZEL_VER}
KERAS_VER=${KERAS_VER}
PYTORCH_VER=${PYTORCH_VER}
NVIDIA_IMAGE_TAG=${NVIDIA_IMAGE_TAG}
BASE_IMAGE_NAME=${BASE_IMAGE_NAME}
TAG=${TAG}
pyVer=${pyVer}
timestamp=${timestamp}
PY_VENV_PATH=${PY_VENV_PATH}
PY_VENV_NAME=${PY_VENV_NAME}
DUSER=${DUSER}
WORK_BASE_PATH=${WORK_BASE_PATH}
OTHR_BASE_PATHS=${OTHR_BASE_PATHS}
DOCKER_BASEPATH=${DOCKER_BASEPATH}
DOCKER_SETUP_PATH=${DOCKER_SETUP_PATH}
WHICHONE=${WHICHONE}
DOCKERFILE=${DOCKERFILE}
MAINTAINER=${MAINTAINER}
EOL

  echo "DOCKERFILE: ${DOCKERFILE}"

  ${DOCKER_CMD} build \
    --build-arg "BASE_IMAGE_NAME=${BASE_IMAGE_NAME}" \
    --build-arg "pyVer=${pyVer}" \
    --build-arg "PY_VENV_PATH=${PY_VENV_PATH}" \
    --build-arg "PY_VENV_NAME=${PY_VENV_NAME}" \
    --build-arg "BAZEL_URL=${BAZEL_URL}" \
    --build-arg "DUSER=${DUSER}" \
    --build-arg "CUDA_VERSION=${CUDA_VERSION}" \
    --build-arg "BUILD_FOR_CUDA_VER=${BUILD_FOR_CUDA_VER}" \
    --build-arg "CUDNN_MAJOR_VERSION=${CUDNN_MAJOR_VERSION}" \
    --build-arg "TENSORRT_VER=${TENSORRT_VER}" \
    --build-arg "LIBNVINFER_VER=${LIBNVINFER_VER}" \
    --build-arg "DUSER_ID=${DUSER_ID}" \
    --build-arg "DUSER_GRP=${DUSER_GRP}" \
    --build-arg "DUSER_GRP_ID=${DUSER_GRP_ID}" \
    --build-arg "WORK_BASE_PATH=${WORK_BASE_PATH}" \
    --build-arg "OTHR_BASE_PATHS=${OTHR_BASE_PATHS}" \
    --build-arg "DOCKER_BASEPATH=${DOCKER_BASEPATH}" \
    --build-arg "DOCKER_SETUP_PATH=${DOCKER_SETUP_PATH}" \
    --build-arg "MAINTAINER=${MAINTAINER}" \
    -t ${TAG} \
    -f ${DOCKERFILE} ${CONTEXT}

  echo -e "Now you can create container:\n source $(pwd)/docker.createcontainer-aidev.sh ${TAG} ${WHICHONE}"
  echo "Enjoy!"
}

## $1 is WHICHONE; refer: docker.config.sh
build_docker_img_aimldl $1
