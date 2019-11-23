#!/bin/bash

##----------------------------------------------------------
### config - path and other configurations
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------

## https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/dockerfiles

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

source $SCRIPTS_DIR/config.basepath.sh

LINUX_SCRIPT_BASE="lscripts"
#echo $LINUX_SCRIPT_BASE
LINUX_SCRIPT_HOME="${SCRIPTS_DIR}/${LINUX_SCRIPT_BASE}"
#echo $LINUX_SCRIPT_HOME

# BASHRC_FILE="${LINUX_SCRIPT_HOME}/config/bashrc"
BASHRC_FILE="${HOME}/.bashrc"
#echo $BASHRC_FILE

## Virtual Machines, Containers, Python virtual environments
VM_BASE="virtualmachines"
VM_HOME="${CHUB_HOME}/$VM_BASE"

PY_VENV_PATH="${VM_HOME}/virtualenvs"
WSGIPYTHONPATH=""
WSGIPYTHONHOME=""

# APACHE_HOME='${HOME}/public_html'

ANDROID_HOME="${CHUB_HOME}/android/sdk"

LINUX_VERSION="$(lsb_release -sr)"
LINUX_CODE_NAME=$(lsb_release -sc)
LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali

source ${LINUX_SCRIPT_HOME}/versions.sh
source ${LINUX_SCRIPT_HOME}/utils/numthreads.sh
source ${LINUX_SCRIPT_HOME}/utils/common.sh
