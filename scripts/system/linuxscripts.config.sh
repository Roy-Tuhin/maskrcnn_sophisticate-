#!/bin/bash

##----------------------------------------------------------
### config - path and other configurations
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

## TODO: verify
## NOTE: Variables should map to scripts/config.sh

## TODO: New mechanism, to be tested thoroughly
LINUX_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

## this is where downloaded softwares gets compiled
BASEDIR="softwares"

BASEPATH="$HOME/$BASEDIR"

## default folder from which softwares are downloaded from internet and used for installation
# DOWNLOADS="$HOME/Downloads"

LINUX_SCRIPT_BASE="${LINUX_SCRIPTS_DIR}"
echo $LINUX_SCRIPT_BASE
LINUX_SCRIPT_HOME="${LINUX_SCRIPTS_DIR}"
echo $LINUX_SCRIPT_HOME

BASHRC_FILE="${HOME}/.bashrc"

## Virtual Machines, Containers, Python virtual environments
VM_BASE="virtualmachines"
VM_HOME="${HOME}/$VM_BASE"
PY_VENV_PATH="${VM_HOME}/virtualenvs"

LINUX_VERSION="$(lsb_release -sr)"
LINUX_CODE_NAME=$(lsb_release -sc)
LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali

source ${LINUX_SCRIPT_HOME}/versions.sh
source ${LINUX_SCRIPT_HOME}/numthreads.sh
source ${LINUX_SCRIPT_HOME}/common.sh

