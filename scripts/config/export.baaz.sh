#!/bin/bash

##----------------------------------------------------------------
## Custom export and alias
##----------------------------------------------------------------

export PY_VENV_PATH=/home/baaz/virtualmachines/virtualenvs
export WORKON_HOME=$PY_VENV_PATH
source /usr/local/bin/virtualenvwrapper.sh

export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

export CUDA_HOME="/usr/local/cuda"
export PATH="/usr/local/cuda/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64"

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export PATH=$PATH:${JAVA_HOME}/bin
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${JAVA_HOME}/server"

## Unset manpath so we can inherit from /etc/manpath via the `manpath` command
#unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export NPM_PACKAGES=${HOME}/.npm-packages

# android adb tool
export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# bender
export PATH=${PATH}:${HOME}/softwares/blender
# meshlab
export PATH=${PATH}:${HOME}/softwares/meshlab/src/distrib
