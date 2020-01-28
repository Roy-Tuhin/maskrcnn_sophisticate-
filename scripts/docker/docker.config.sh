#!/bin/bash

##----------------------------------------------------------
### config - path and other configurations
## Tested on  Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------

local __TIMESTAMP__=$(date +%Y%m%d_%H%M)
local timestamp=${__TIMESTAMP__}

local VERSION=8
local WHICHONE

WHICHONE="aidevmin-devel-gpu"
WHICHONE="aidev-devel-gpu"

if [ ! -z $1 ]; then
  WHICHONE=$1
fi
echo "WHICHONE: ${WHICHONE}"
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/dockerfiles/installer/lscripts/lscripts.config.sh

local NVIDIA_IMAGE_TAG=${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}

local BASE_IMAGE_NAME="nvidia/cuda:${NVIDIA_IMAGE_TAG}"
local TAG="mangalbhaskar/aimldl:${NVIDIA_IMAGE_TAG}-$(echo ${WHICHONE}|cut -d'-' -f1)-v${VERSION}-${timestamp}"
local DOCKERFILE="dockerfiles/${WHICHONE}.Dockerfile"
local DOCKER_IMG=${TAG}

echo "DOCKERFILE: ${DOCKERFILE}"

if [ ! -f ${DOCKERFILE} ];then
  echo "${DOCKERFILE} does not exits"
else
  echo "Docker file to be used: ${DOCKERFILE}"
fi

#
local pyVer=3
local PY_VENV_PATH="/virtualmachines/virtualenvs"
local PY_VENV_NAME=py_${pyVer}_${timestamp}

## DUSER gets baked inside the docker image during build process.
## It generally would be different if you are using the image built by someoneelse or built on different machine with different username

## host user: used during creating of the docker container
local HUSER=${USER}
local HUSER_ID=$(id -u ${HUSER})
local HUSER_GRP=$(id -gn ${HUSER})
local HUSER_GRP_ID=$(id -g ${HUSER})
local HUSER_HOME="/home/${HUSER}"

if [ "${HUSER}" == "root" ];then
  HUSER_HOME="/root"
fi

## docker user: used during building docker image
local DUSER=${USER}
local DUSER_ID=$(id -u ${DUSER})
local DUSER_GRP=$(id -gn ${DUSER})
local DUSER_GRP_ID=$(id -g ${DUSER})
local DUSER_HOME="/home/${DUSER}"
#

local DOCKER_PREFIX="codehub"
#
local MAINTAINER='"mangalbhaskar"'
#
local DOCKER_BASEPATH="/external4docker"
local DOCKER_SETUP_PATH="/docker-installer"

local DOCKER_CONTAINER_NAME="${WHICHONE}-${VERSION}"

local LOCAL_HOST=`hostname`
local DOCKER_LOCAL_HOST="${DOCKER_PREFIX}-docker"

local WORK_BASE_PATH="/${DOCKER_PREFIX}"
local SCRIPTS_BASE_PATH="/${DOCKER_PREFIX}-scripts"

## https://github.com/mangalbhaskar/aimldl/blob/master/readme/how_to_clone_and_create_the_git_repo_first_time_setup.md
local OTHR_BASE_PATHS="/aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat"


if [ -z ${DOCKER_VOLUMES} ]; then
  local DOCKER_VOLUMES=""
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
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /aimldl-mnt:/aimldl-mnt "

DOCKER_VOLUMES="${DOCKER_VOLUMES} ${MONGODB_VOLUMES} "

if [ -z ${DOCKER_PORTS} ]; then
  local DOCKER_PORTS=""
fi

DOCKER_PORTS="${DOCKER_PORTS} ${MONGO_DB_PORTS}"

local DDISPLAY="${DISPLAY}"
if [[ -z ${DISPLAY} ]];then
  DDISPLAY=":0"
fi

local DOCKER_ENVVARS=""

local SHM_SIZE=2G

local DOCKER_CMD="docker"
local DOCKER_VERSION=$(docker --version | cut -d',' -f1 | cut -d' ' -f3)
# local DOCKER_CMD="docker-compose"

# local DOCKER_CONTAINER_IMG="mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20200122_1504"
local DOCKER_CONTAINER_IMG=${TAG}
