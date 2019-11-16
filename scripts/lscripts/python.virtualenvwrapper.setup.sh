#!/bin/bash

##----------------------------------------------------------
### Python create virtualenvs skeleton
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Ref: python.virtualenvwrapper.install.sh
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

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$PY_VENV_PATH" ]; then
  PY_VENV_PATH=$HOME/virtualmachines/virtualenvs
  echo "Unable to get PY_VENV_PATH, using default path#: $PY_VENV_PATH"
fi


## Ref:
## https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function
## Variable Leaks:
##  * https://stackoverflow.com/questions/30609973/bash-variable-scope-leak
create_and_setup_py_env() {
  local py=$1
  local pip=$2
  local py_env_prefix=$3

  local pipPath pipVer py_env_name pyPath pyVer
  local timestamp

  echo "create_and_setup_py_env:py: $1"
  echo "create_and_setup_py_env:pip: $2"

  ## return ## for testing
  timestamp=$(date +%Y-%m-%d) ## $(date +%Y%m%d%H%M%S)
  pyPath=$(which $py)

  ## Ref
  ## https://stackoverflow.com/questions/6141581/detect-python-version-in-shell-script
  # python -c 'import sys; print(sys.version_info[:])'
  # python -c 'import sys; print sys.version_info'
  # python -c 'import platform; print(platform.python_version())'
  # version=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')

  pyVer=$($py -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')

  echo "##--------------------------------------------------------##"

  ## Ref:
  ## https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs
  ## http://www.tldp.org/LDP/abs/html/exitcodes.html
  if [[ -z "$pyVer" ]]; then
      echo "No Python!"
      return
  else
    echo "Python version: $pyVer"
  fi

  pipPath=$(which $pip)
  pipVer=$($pip --version)

  echo "$pyPath: $pyVer"
  echo "$pipPath: $pipVer"

  py_env_name=$py_env_prefix"py_"$pyVer"_"$timestamp
  echo "Creating: $py_env_name folder inside: $PY_VENV_PATH"

  # rmvirtualenv $py_env_name
  mkvirtualenv -p $pyPath $py_env_name
  
  echo "## List all of the environments."
  lsvirtualenv

  workon $py_env_name
  echo "Installing basic required packages given in file: python.requirements.txt"
  echo "You can Install additional packages from: python.requirements-extras.txt"
  echo "You can Install additional packages from: python.requirements-ai.txt"
  
  ## testing
  # deactivate
  # rmvirtualenv $py_env_name

  $pip install -r python.requirements.txt
  # $pip install -r python.requirements-extras.txt
  # $pip install -r python.requirements-ai.txt

  echo "## Install AI frameworks:"
  echo "## manually: Tensorflow, Caffe, Keras"
  echo "## already in python.requirements-ai.txt: theano"
  echo ""
  echo "install OpenCV only in virtualenv: copy from system"
  echo "# cp /usr/local/lib/python2.7/dist-packages/cv2.so <pathToVirtualEnv>/lib/python2.7/site-packages"
  echo "# cp /usr/local/lib/python3.6/dist-packages/cv2.cpython-36m-x86_64-linux-gnu.so  <pathToVirtualEnv>/lib/python3.6/site-packages"
  echo ""
  echo "## copy pygpu manually to virtualenv (as somehow it does nto get installed directly on virtualenv)"
  echo "## Try copying:"
  echo "## pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg"
  echo "## OR"
  echo "## pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg/pygpu"
  echo "# cp -r /usr/local/lib/python3.6/dist-packages/pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg/pygpu $PY_VENV_PATH/py_3-6-5_2018-11-20/lib/python3.6/site-packages/."
  echo "# cp -r /usr/local/lib/python2.7/dist-packages/pygpu-0.7.6+5.g8786e0f-py2.7-linux-x86_64.egg/pygpu $PY_VENV_PATH/py_2-7-15_2018-11-20/lib/python2.7/site-packages/."
  echo ""

  echo "##-----------------X---X---X------------------------------##"
}

main_create_and_setup_py_env() {
  local _py _pip _py_env_prefix

  if [[ -z "$1" ]]; then
    _py=python2
    _pip=pip2
  else
    _py=python$1
    _pip=pip$1
  fi

  if [[ -z "$2" ]]; then
    _py_env_prefix=""
  else
    _py_env_prefix="$2_"
  fi

  create_and_setup_py_env $_py $_pip $_py_env_prefix
}

main_create_and_setup_py_env $1 $2
