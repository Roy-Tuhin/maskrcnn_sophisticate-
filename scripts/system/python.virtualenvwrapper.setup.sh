#!/bin/bash

##----------------------------------------------------------
### Python create virtualenvs skeleton
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Ref: python.virtualenvwrapper.install.sh
#
## Ref
## https://stackoverflow.com/questions/6141581/detect-python-version-in-shell-script
# python -c 'import sys; print(sys.version_info[:])'
# python -c 'import sys; print sys.version_info'
# python -c 'import platform; print(platform.python_version())'
# version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
#
## https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function
## Variable Leaks:
##  * https://stackoverflow.com/questions/30609973/bash-variable-scope-leak
#
## https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs
## http://www.tldp.org/LDP/abs/html/exitcodes.html
#
##----------------------------------------------------------
## Usage:
##----------------------------------------------------------
# Creates Virtaulenv with names as:
## <python_env_prefix>_py_<maj-min-rel>_YYYY-MM-DD
## OR
## py_<maj-min-rel>_YYYY-MM-DD
#
## source python.virtualenvwrapper.setup.sh
## source python.virtualenvwrapper.setup.sh [2|3] [<python_env_prefix>]
#
##----------------------------------------------------------

function python_virtualenvwrapper_setup() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ ! -z $1 ]; then
    local pyVer=$1
    info "Using pyVer#: ${pyVer}"
  fi
  if [ ! -z $2]; then
    local pyEnvName=$2
    info "Using pyEnvName: ${pyEnvName}"
  fi

  if [ -z "${PY_VENV_PATH}" ]; then
    PY_VENV_PATH=${HOME}/virtualmachines/virtualenvs
    info "Unable to get PY_VENV_PATH, using default path#: ${PY_VENV_PATH}"
  fi

  info "PY_VENV_PATH: ${PY_VENV_PATH}"

  export WORKON_HOME=${PY_VENV_PATH}
  # source ${PY_VIRTUALENVWRAPPER}

  function create_and_setup_py_env() {
    local py=python3
    local pip=pip3
    local _py_env_name=""

    if [ ! -z $1 ]; then
      py=python$1
      pip=pip$1
    fi

    if [ ! -z $2 ]; then
      _py_env_name=$2
    fi

    info "create_and_setup_py_env:py: ${py}; pip: ${pip}"

    local py_env_name
    local pyVer
    local timestamp=$(date +%Y-%m-%d) ## $(date +%Y%m%d%H%M%S)
    local pyPath=$(which ${py})
    local pipPath=$(which ${pip})
    local pipVer=$(${pip} --version)

    info "pyPath: ${pyVer}"
    info "pipPath: ${pipVer}"

    pyVer=$(${py} -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')

    if [ -z "${pyVer}" ]; then
        info "No Python!"
        return
    else
      info "Python version: ${pyVer}"
    fi

    py_env_name="py_"${pyVer}"_"${timestamp}
    if [ ! -z ${_py_env_name} ]; then
      py_env_name=${_py_env_name}
    fi

    info "Creating: ${py_env_name} folder inside: ${PY_VENV_PATH}"
    info "##--------------------------------------------------------##"

    ## return ## for testing
    mkvirtualenv -p ${pyPath} ${py_env_name}
    
    info "## List all of the environments."
    lsvirtualenv

    workon ${py_env_name}
    info "Installing basic required packages given in file: python.requirements.txt"
    info "You can Install additional packages from: python.requirements-extras.txt"
    info "You can Install additional packages from: python.requirements-ai.txt"
    info "You can Install Python AI packages specific to cuda version from: AI_PYCUDA_FILE: ${LSCRIPTS}/${AI_PYCUDA_FILE}"
    
    # ## testing
    # info "deactivating and removing Virtaulenv"
    # deactivate
    # rmvirtualenv ${py_env_name}

    ${pip} install -r ${LSCRIPTS}/python.requirements-test.txt

    # ${pip} install -r ${LSCRIPTS}/python.requirements.txt
    # ${pip} install -r ${LSCRIPTS}/python.requirements-extras.txt
    # # ${pip} install -r ${LSCRIPTS}/python.requirements-ai.txt
    # ${pip} install -r ${LSCRIPTS}/${AI_PYCUDA_FILE}


    # info ""
    # info "install OpenCV only in virtualenv: copy from system"
    # info "# cp /usr/local/lib/python2.7/dist-packages/cv2.so <pathToVirtualEnv>/lib/python2.7/site-packages"
    # info "# cp /usr/local/lib/python3.6/dist-packages/cv2.cpython-36m-x86_64-linux-gnu.so  <pathToVirtualEnv>/lib/python3.6/site-packages"
    # info ""
    # info "## copy pygpu manually to virtualenv (as somehow it does nto get installed directly on virtualenv)"
    # info "## Try copying:"
    # info "## pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg"
    # info "## OR"
    # info "## pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg/pygpu"
    # info "# cp -r /usr/local/lib/python3.6/dist-packages/pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg/pygpu $PY_VENV_PATH/py_3-6-5_2018-11-20/lib/python3.6/site-packages/."
    # info "# cp -r /usr/local/lib/python2.7/dist-packages/pygpu-0.7.6+5.g8786e0f-py2.7-linux-x86_64.egg/pygpu $PY_VENV_PATH/py_2-7-15_2018-11-20/lib/python2.7/site-packages/."
    # info ""

    # info "##-----------------X---X---X------------------------------##"
  }

  create_and_setup_py_env ${pyVer} ${pyEnvName}
}

python_virtualenvwrapper_setup $1 $2
