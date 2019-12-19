#!/bin/bash

##----------------------------------------------------------
### config - path and other configurations
## Tested on  Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------

__TIMESTAMP__=$(date +%Y%m%d_%H%M)
timestamp=${__TIMESTAMP__}

VERSION=7
WHICHONE="aidevmin-devel-gpu"
WHICHONE="aidev-devel-gpu"

if [ ! -z $1 ]; then
  WHICHONE=$1
fi
echo "WHICHONE: ${WHICHONE}"

if [ -z $2 ]; then
  # BUILD_FOR_CUDA_VER=9.0
  BUILD_FOR_CUDA_VER=10.0
fi
echo "DOCKERFILE BUILD_FOR_CUDA_VER: ${BUILD_FOR_CUDA_VER}"

source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/dockerfiles/installer/lscripts/lscripts.config.sh ${BUILD_FOR_CUDA_VER}

NVIDIA_IMAGE_TAG=${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}

BASE_IMAGE_NAME="nvidia/cuda:${NVIDIA_IMAGE_TAG}"
TAG="mangalbhaskar/aimldl:${NVIDIA_IMAGE_TAG}-$(echo ${WHICHONE}|cut -d'-' -f1)-v${VERSION}-${timestamp}"
DOCKERFILE="dockerfiles/${WHICHONE}.Dockerfile"
DOCKER_IMG=${TAG}

echo "DOCKERFILE: ${DOCKERFILE}"

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
OTHR_BASE_PATHS="/aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat"


if [ -z ${DOCKER_VOLUMES} ]; then
  DOCKER_VOLUMES=""
fi

DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub:/codehub "

# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/external4docker:/external4docker "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/external4docker:${DOCKER_BASEPATH} "

# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/scripts:/codehub-scripts"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub/scripts:${SCRIPTS_BASE_PATH} "

DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cod:/aimldl-cod "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-cod/scripts:/aimldl-scripts "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-dat:/aimldl-dat "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-rpt:/aimldl-rpt "
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-doc:/aimldl-doc "

DOCKER_VOLUMES="${DOCKER_VOLUMES} ${MONGODB_VOLUMES} "

if [ -z ${DOCKER_PORTS} ]; then
  DOCKER_PORTS=""
fi

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
