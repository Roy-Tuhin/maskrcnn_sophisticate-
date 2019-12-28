#!/bin/bash


function python_config() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ ! -z $1 ]; then
    local pyVer=$1
    echo "Using pyVer#: ${pyVer}"
  fi

  pyVer=3
  local PYTHON=python${pyVer}
  local PIP=pip${pyVer}

  local pylink=/usr/bin/python
  local piplink=/usr/bin/pip

  if [ -L "${pylink}" ]; then
    echo "removing existing link...: ${pylink}"
    ls -l ${pylink}
    sudo rm -f ${pylink}
  fi

  if [ -L "${piplink}" ]; then
    echo "removing existing link...: ${piplink}"
    ls -l ${piplink}
    sudo rm -f ${piplink}
  fi

  sudo ln -s $(which ${PYTHON}) ${pylink}
  sudo ln -s $(which ${PIP}) ${piplink}

  ls -l ${pylink}
  ls -l ${piplink}
}

python_config
