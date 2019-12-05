#!/bin/bash

timestamp=$(date +%Y%m%d_%H%M)

LINUX_VERSION="$(lsb_release -sr)"
LINUX_CODE_NAME=$(lsb_release -sc)
LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali

OS="ubuntu18.04"
CUDA_VERSION=10.0
CUDNN_VERSION="7.6.4.38"
CUDNN_MAJOR_VERSION=7
TENSORRT_VERSION=5
# sudo apt install libnvinfer5=5.1.2-1+cuda10.0

# #
# OS="ubuntu16.04"
# CUDA_VERSION=9.0
# CUDNN_VERSION="7.6.4.38"
# CUDNN_MAJOR_VERSION=7
# TENSORRT_VERSION=4
#

TF_VERSION=1.13.1

NVIDIA_IMAGE_TAG=${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}

VERSION=5
WHICHONE="aidev-devel-gpu"
WHICHONE="aidevmin-devel-gpu"

if [ ! -z $1 ]; then
  WHICHONE=$1
fi
echo "WHICHONE: ${WHICHONE}"

BASE_IMAGE_NAME="nvidia/cuda:${NVIDIA_IMAGE_TAG}"
TAG="mangalbhaskar/aimldl:${NVIDIA_IMAGE_TAG}-$(echo ${WHICHONE}|cut -d'-' -f1)-v${VERSION}-tf${TF_VERSION}-${timestamp}"
DOCKERFILE="dockerfiles/${WHICHONE}.Dockerfile"
DOCKER_IMG=${TAG}

if [ ! -f ${DOCKERFILE} ];then
  echo "${DOCKERFILE} does not exits"
else
  echo "Docker file to be used: ${DOCKERFILE}"
fi

#
pyVer=3
PY_VENV_PATH="/virtualmachines/virtualenvs"
PY_VENV_NAME=py_${pyVer}_${timestamp}

## DUSER gets baked inside the docker image during build process.
## It generally would be different if you are using the image built by someoneelse or built on different machine with different username

## host user: used during creating of the docker container
HUSER=${USER}
HUSER_ID=$(id -u ${HUSER})
HUSER_GRP=$(id -gn ${HUSER})
HUSER_GRP_ID=$(id -g ${HUSER})
HUSER_HOME="/home/${HUSER}"

if [ "${HUSER}" == "root" ];then
  HUSER_HOME="/root"
fi

## docker user: used during building docker image
DUSER=${USER}
DUSER_ID=$(id -u ${DUSER})
DUSER_GRP=$(id -gn ${DUSER})
DUSER_GRP_ID=$(id -g ${DUSER})
DUSER_HOME="/home/${DUSER}"
#

## MongoDB configurations
HOST_MONGODB_PORTS="27017"
DOCKER_MONGODB_PORTS="27017"
MONGODB_CONFIG_FILE="/aimldl-cfg/config/mongod.conf"
# MONGO_INITDB_ROOT_USERNAME=""
# MONGO_INITDB_ROOT_PASSWORD=""
MONGODB_USER=$(id -un mongodb)
MONGODB_USER_ID=$(id -u mongodb)
MONGODB_GRP=$(id -gn mongodb)
MONGODB_GRP_ID=$(id -g mongodb)

MONGODB_VOLUMES=""
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat/data-mongodb:/data "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat/data-mongodb/db:/data/db "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat/data-mongodb/configdb:/data/configdb "

MONGO_DB_PORTS=""
MONGO_DB_PORTS="${MONGO_DB_PORTS} -p ${HOST_MONGODB_PORTS}:${DOCKER_MONGODB_PORTS}"

## bazel configuration for compiling tensorflow from source
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
DOCKER_BASEPATH="/external4docker"
DOCKER_SETUP_PATH="/docker-installer"

DOCKER_CONTAINER_NAME="${WHICHONE}-${VERSION}"

LOCAL_HOST=`hostname`
DOCKER_LOCAL_HOST="${DOCKER_PREFIX}-docker"

WORK_BASE_PATH="/${DOCKER_PREFIX}"
SCRIPTS_BASE_PATH="/${DOCKER_PREFIX}-scripts"

## https://github.com/mangalbhaskar/aimldl/blob/master/readme/how_to_clone_and_create_the_git_repo_first_time_setup.md
OTHR_BASE_PATHS="/aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg"

DOCKER_VOLUMES=""

DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub:/codehub "

# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/external4docker:/external4docker "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/external4docker:${DOCKER_BASEPATH} "

# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/scripts:/codehub-scripts"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/scripts:${SCRIPTS_BASE_PATH} "

DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cod:/aimldl-cod "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cod/scripts:/aimldl-scripts "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-dat:/aimldl-dat "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cfg:/aimldl-cfg "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-rpt:/aimldl-rpt "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-doc:/aimldl-doc "

DOCKER_VOLUMES="${DOCKER_VOLUMES} ${MONGODB_VOLUMES} "

DOCKER_PORTS=""
DOCKER_PORTS="${DOCKER_PORTS} ${MONGO_DB_PORTS}"

DDISPLAY="${DISPLAY}"
if [[ -z ${DISPLAY} ]];then
  DDISPLAY=":0"
fi

DOCKER_ENVVARS=""

SHM_SIZE=2G

DOCKER_CMD="docker"
DOCKER_VERSION=$(docker --version | cut -d',' -f1 | cut -d' ' -f3)
# DOCKER_CMD="docker-compose"

DOCKER_CONTAINER_IMG="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-4-20191128_1444"
