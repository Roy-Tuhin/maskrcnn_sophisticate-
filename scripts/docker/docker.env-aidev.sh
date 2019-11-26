#!/in/bash

OS="ubuntu18.04"
CUDA_VERSION=10.0
CUDNN_VERSION="7.6.4.38"
CUDNN_MAJOR_VERSION=7
nvidia_image_tag=${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}
#
VERSION=4
WHICHONE="aidev"
BASE_IMAGE_NAME="nvidia/cuda:${nvidia_image_tag}"
TAG="mangalbhaskar/aimldl:${nvidia_image_tag}-${WHICHONE}-${VERSION}"
DOCKERFILE="${WHICHONE}/Dockerfile"
DOCKER_IMG=${TAG}

#
pyVer=3
timestamp=$(date +%Y%m%d_%H%M)
PY_VENV_PATH="/virtualmachines/virtualenvs"
PY_VENV_NAME=py_${pyVer}_${timestamp}
DUSER=${USER}
#

_TF_MIN_BAZEL_VERSION='0.24.1'
_TF_MAX_BAZEL_VERSION='0.26.1'
BAZEL_VERSION=1.1.0
BAZEL_VERSION=${_TF_MAX_BAZEL_VERSION}
BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"
#
DOCKER_PREFIX="codehub"
#
MAINTAINER='"mangalbhaskar <mangalbhaskar@gmail.com>"'
#
DOCKER_CMD="docker"
DOCKER_HOME="/home/${DUSER}"
DOCKER_BASEPATH="/external4docker"


DOCKER_CONTAINER_NAME="${WHICHONE}-${VERSION}"

LOCAL_HOST=`hostname`
DOCKER_LOCAL_HOST="${DOCKER_PREFIX}-docker"

WORK_BASE_PATH="/${DOCKER_PREFIX}"
SCRIPTS_BASE_PATH="/${DOCKER_PREFIX}-scripts"

## https://github.com/mangalbhaskar/aimldl/blob/master/readme/how_to_clone_and_create_the_git_repo_first_time_setup.md
OTHR_BASE_PATHS="/aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg"

DOCKER_VOLUMES=""
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${SCRIPTS_DIR}:${SCRIPTS_BASE_PATH}"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub:/codehub"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cod:/aimldl-cod"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-doc:/aimldl-doc"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-dat:/aimldl-dat"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cfg:/aimldl-cfg"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-rpt:/aimldl-rpt"

SHM_SIZE=2G

if [ "${USER}" == "root" ];then
    DOCKER_HOME="/root"
fi

LINUX_VERSION="$(lsb_release -sr)"
LINUX_CODE_NAME=$(lsb_release -sc)
LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali
