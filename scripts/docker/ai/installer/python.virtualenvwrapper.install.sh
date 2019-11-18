#!/bin/bash

##----------------------------------------------------------
### Python virtualenv virtualenvwrapper setup
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## **How can we run 3 different python applications on 3 different python versions on same machine?**
#
## http://rafiqnayan.blogspot.com/2018/03/deploy-python-application-with-gunicorn.html
## - Best illustration: virtualenv, virtualenvwrapper, supervisor
#
##----------------------------------------------------------
## Usage:
##----------------------------------------------------------
## Ref: python.virtualenvwrapper.setup.sh
#
## source python.virtualenvwrapper.install.sh
## source python.virtualenvwrapper.install.sh [2|3] [<python_env_prefix>]
#
##----------------------------------------------------------
#
## TBD:
## - link it with python installation
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

echo "PY_VENV_PATH: $PY_VENV_PATH"

install_py_env() {
  local FILE LINE
  local test_env_name

  ## Install virtualenv virtualenvwrapper with Py2
  sudo pip2 install virtualenv virtualenvwrapper
  echo "virtualenv version::"
  virtualenv --version

  echo "Creating central folder where all the virtualenvs would be created: $PY_VENV_PATH"
  mkdir -p $PY_VENV_PATH
  #
  FILE=$HOME/.bashrc
  #
  LINE="export PY_VENV_PATH=$PY_VENV_PATH"
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  #
  LINE='export WORKON_HOME=$PY_VENV_PATH'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  #
  LINE='source /usr/local/bin/virtualenvwrapper.sh'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  #
  source $FILE

  ##----------------------------------------------------------
  ## Usage
  ##----------------------------------------------------------

  echo "Testing Usage and Installation: "
  test_env_name=test_$(date +%Y%m%d%H%M%S)
  echo "Creating test_env_name: $test_env_name folder inside: $PY_VENV_PATH"
  ## creates the my_project folder inside $PY_VENV_PATH
  mkvirtualenv $test_env_name

  echo "lsvirtualenv: ## List all of the environments."
  lsvirtualenv

  echo "cdvirtualenv: ## Navigate into the directory of the currently activated virtual environment, so you can browse its site-packages."
  cdvirtualenv

  echo "cdsitepackages: ## Like the above, but directly into site-packages directory."
  cdsitepackages

  echo "lssitepackages: ## Shows contents of site-packages directory."
  lssitepackages
  #
  echo "workon <test_env_name>: ## workon also deactivates whatever environment you are currently in, so you can quickly switch between environments."
  echo "workon $test_env_name"
  workon $test_env_name
  ##
  echo "deactivate: ## Deactivates whatever environment you are currently in."
  deactivate
  #
  ## Rename
  ## https://stackoverflow.com/questions/9540040/rename-an-environment-with-virtualenvwrapper
  echo "cpvirtualenv <test_env_name> new_<test_env_name>: ## copy the virtualenv environment. Used as workaround for renaming."
  cpvirtualenv $test_env_name new_$test_env_name
  deactivate
  rmvirtualenv $test_env_name

  ## Remove
  echo "rmvirtualenv new_<test_env_name>: ## Removes the virtualenv environment."
  rmvirtualenv "new_$test_env_name"
}

##----------------------------------------------------------

install_py_env

cd $LINUX_SCRIPT_HOME

source $LSCRIPTS/python.virtualenvwrapper.setup.sh $1 $2
