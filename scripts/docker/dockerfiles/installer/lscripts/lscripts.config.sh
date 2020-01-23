#!/bin/bash

local __TIMESTAMP__=$(date +%Y%m%d_%H%M)
local timestamp=${__TIMESTAMP__}

local LINUX_SCRIPT_BASE="lscripts"
local LINUX_SCRIPT_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

# BASHRC_FILE="${LINUX_SCRIPT_HOME}/config/bashrc"
local BASHRC_FILE=${HOME}/.bashrc
#echo ${BASHRC_FILE}
local USER_BASHRC_FILE="${HOME}/.bashrc"

local APACHE_HOME='${HOME}/public_html'

local LINUX_VERSION="$(lsb_release -sr)"
local LINUX_CODE_NAME=$(lsb_release -sc)
local LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali

# local pyVer=3

local BASEDIR="external"
local CHUB_DIR="codehub"
local CHUB_HOME="/${CHUB_DIR}"
## local BASEPATH="${HOME}/${BASEDIR}"
local BASEPATH="${CHUB_HOME}/${BASEDIR}"
local DOCKER_BASEPATH="/external4docker"

## Virtual Machines, Containers, Python virtual environments
local pyVer=3
local PY_VENV_NAME=py_${pyVer}_${__TIMESTAMP__}
local PY_VENV_LINK_NAME=py_${pyVer}
local VM_BASE="virtualmachines"
# local VM_HOME=/${VM_BASE}
# local VM_HOME="${CHUB_HOME}/${VM_BASE}"
local VM_HOME="/${VM_BASE}"
local PY_VENV_PATH="${VM_HOME}/virtualenvs"

local PY_VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh

local WSGIPYTHONPATH=""
local WSGIPYTHONHOME=""

local ANDROID_HOME=${CHUB_HOME}/android/sdk

source ${LINUX_SCRIPT_HOME}/versions.sh
source ${LINUX_SCRIPT_HOME}/utils/numthreads.sh
source ${LINUX_SCRIPT_HOME}/utils/common.sh

echo "BUILD_FOR_CUDA_VER: ${BUILD_FOR_CUDA_VER}"
local CUDACFG_FILEPATH=${LINUX_SCRIPT_HOME}/cudacfg-${BUILD_FOR_CUDA_VER}.sh
echo "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

local AI_PYCUDA_FILE=python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
echo "AI_PYCUDA_FILE: ${AI_PYCUDA_FILE}"

if [ -f ${CUDACFG_FILEPATH} ]; then
  source ${CUDACFG_FILEPATH}
else
  echo "ERROR: CUDA compatibility is not yet identified for: ${BUILD_FOR_CUDA_VER}"
  return
fi
