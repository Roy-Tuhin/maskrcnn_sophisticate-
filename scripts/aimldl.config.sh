#!/bin/bash

## This config can also be used to overrides the default environment variables only for the current shell
## by including in the main executing script

AI_BASEPATH=""
AI_CODE_BASE_PATH="/codehub"
AI_DIR_PREFIX="aimldl"
AI_GOOGLE_APPLICATION_CREDENTIALS_FILE=""
AI_MOUNT_MACHPREFIX='vtq' ## possible values: 'vtd' or 'mmi'
AI_VM_BASE="virtualmachines"
AI_VM_HOME=${AI_CODE_BASE_PATH}/${AI_VM_BASE}
AI_PY_VENV_PATH=${AI_VM_HOME}/virtualenvs

WORKON_HOME=${AI_PY_VENV_PATH}
AI_VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh

## What Is /dev/shm And Its Practical Usage?
## https://www.cyberciti.biz/tips/what-is-devshm-and-its-practical-usage.html


## AI Top Level Directories
AI_CFG_BASE_PATH="${AI_CODE_BASE_PATH}/cfg"
AI_DATA_BASE_PATH="/${AI_DIR_PREFIX}-dat"
AI_MOUNT_BASE_PATH="/${AI_DIR_PREFIX}-mnt"
AI_DOC_BASE_PATH="/${AI_DIR_PREFIX}-doc"
AI_RPT_BASE_PATH="/${AI_DIR_PREFIX}-rpt"
AI_KBANK_BASE_PATH="/${AI_DIR_PREFIX}-kbank"

declare -a AI_CFG_DIRS=(
  "model"
  "model/release"
  "dataset"
  "arch"
)

declare -a AI_DATA_DIRS=(
  "data-mongodb"
  "data-mongodb/db"
  "data-mongodb/logs"
  "data-mongodb/key"
  "data-mongodb/configdb"
  "data-public"
  "data-gaze"
  "data-gaze/AIML_Annotation"
  "data-gaze/AIML_Database"
  "data-gaze/AIML_Aids"
  "data-gaze/AIML_Database_Test"
  "data-gaze/AIML_Aids_Test"
  "logs"
  "logs/www"
  "logs/www/uploads"
  "samples"
  "release"
)


declare -a AI_PY_ENVVARS=(
  'AI_APP'
  'AI_HOME_EXT'
  'MASK_RCNN'
  'FASTER_RCNN'
  'CAFFE_ROOT'
  'AI_LANENET_ROOT'
)

declare -a AI_REMOTE_MACHINE_IDS=(
  "alpha"
  "jarvis"
  "ultron"
  "venom"
  "flash"
  "samba-100"
)

## ----------IMP--------------------##
## This has to be changed manually, and aimldl.setup.sh needs to be executed again!
AI_PYVER=3
AI_PY_VENV_NAME="py_3-6-9_2019-12-19"

AI_WSGIPythonPath="${AI_PY_VENV_NAME}/bin"
AI_WSGIPythonHome="${AI_PY_VENV_NAME}/lib/python3.6/site-packages/"
## ---------------------------------##

AI_ANNON_DATA_HOME="/data/samba/Bangalore/prod/Bangalore_Maze_Exported_Data/ANNOTATIONS"
AI_ANNON_DB="/aimldl-dat/data-gaze/AIML_Database"
AI_ANNON_DB_TEST="/aimldl-dat/data-gaze/AIML_Database_Test"
# AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation"
# AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/*/annotations"
# AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719"
AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_290719"
AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_240919_121321"
AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719"
# AI_ANNON_DATA_HOME="${AI_ANNON_DATA_HOME_LOCAL}"

## Inspired by:
## https://github.com/ApolloAuto/apollo/tree/master/scripts

## absoulte path will always be /aimldl-dat
AI_WEIGHTS_PATH="release" ## default value for production/CBR release

## uncomment and give custom relative path for model - should be used for development work
# AI_WEIGHTS_PATH="logs"


