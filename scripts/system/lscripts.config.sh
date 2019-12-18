#!/bin/bash

__TIMESTAMP__=$(date +%Y%m%d_%H%M)

LINUX_SCRIPT_BASE="system"
LINUX_SCRIPT_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

# BASHRC_FILE="${LINUX_SCRIPT_HOME}/config/bashrc"
BASHRC_FILE=${HOME}/.bashrc
#echo ${BASHRC_FILE}
USER_BASHRC_FILE="${HOME}/.bashrc"

APACHE_HOME='${HOME}/public_html'

LINUX_VERSION="$(lsb_release -sr)"
LINUX_CODE_NAME=$(lsb_release -sc)
LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali

# pyVer=3

BASEDIR="external"
CHUB_DIR="codehub"
VM_BASE="virtualmachines"
CHUB_HOME="/${CHUB_DIR}"
## BASEPATH="${HOME}/${BASEDIR}"
BASEPATH="${CHUB_HOME}/${BASEDIR}"
DOCKER_BASEPATH="/external4docker"
## Virtual Machines, Containers, Python virtual environments
# VM_HOME=/${VM_BASE}
pyVer=3
VM_HOME=${CHUB_HOME}/${VM_BASE}
PY_VENV_PATH=${VM_HOME}/virtualenvs
PY_VENV_NAME=py_${pyVer}_${__TIMESTAMP__}

PY_VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh

WSGIPYTHONPATH=""
WSGIPYTHONHOME=""

ANDROID_HOME=${CHUB_HOME}/android/sdk

source ${LINUX_SCRIPT_HOME}/versions.sh
source ${LINUX_SCRIPT_HOME}/utils/numthreads.sh
source ${LINUX_SCRIPT_HOME}/utils/common.sh

if [ -z $1 ]; then
  # BUILD_FOR_CUDA_VER=9.0
  BUILD_FOR_CUDA_VER=10.0
fi
echo "BUILD_FOR_CUDA_VER: ${BUILD_FOR_CUDA_VER}"

CUDACFG_FILEPATH=${LINUX_SCRIPT_HOME}/cudacfg-${BUILD_FOR_CUDA_VER}.sh
AI_PYCUDA_FILE=python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt

if [ -f ${CUDACFG_FILEPATH} ]; then
  source ${CUDACFG_FILEPATH}
else
  echo "ERROR: CUDA compatibility is not yet identified for: ${BUILD_FOR_CUDA_VER}"
  return
fi
