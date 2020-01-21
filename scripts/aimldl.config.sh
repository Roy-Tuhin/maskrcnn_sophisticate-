#!/bin/bash

## CAUTIOUS:
## Ensure that environment variable exports should not have the user name printed in the export script
## Use single quotes to ensure the environment variables does not get expanded


## This config can also be used to overrides the default environment variables only for the current shell
## by including in the main executing script

declare -a AI_CFG_DIRS=(
  "model"
  "model/release"
  "dataset"
  "arch"
)

declare -a AI_DATA_DIRS=(
  "data-gaze"
  "data-gaze/AIML_Annotation"
  "data-gaze/AIML_Database"
  "data-gaze/AIML_Aids"
  "data-gaze/AIML_Database_Test"
  "data-gaze/AIML_Aids_Test"
  "data-mongodb"
  "data-mongodb/db"
  "data-mongodb/logs"
  "data-mongodb/key"
  "data-mongodb/configdb"
  "data-mobile"
  "data-public"
  "logs"
  "logs/www"
  "logs/www/uploads"
  "samples"
  "release"
)

## ---------------------------------##

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

## ---------------------------------##

local MONOGODB_USER=mongodb
local MONOGODB_GROUP=mongodb

## ---------------------------------##

local AI_BASEPATH=""
local AI_CODE_BASE_PATH="/codehub"
local AI_DIR_PREFIX="aimldl"
local AI_GOOGLE_APPLICATION_CREDENTIALS_FILE=""
local AI_MOUNT_MACHPREFIX='vtq' ## possible values: 'vtd' or 'mmi'
local AI_VM_BASE="virtualmachines"
# local AI_VM_HOME=${AI_CODE_BASE_PATH}/${AI_VM_BASE}
local AI_VM_HOME=/${AI_VM_BASE}
local AI_PY_VENV_PATH=${AI_VM_HOME}/virtualenvs

local WORKON_HOME=${AI_PY_VENV_PATH}
local AI_VIRTUALENVWRAPPER=/usr/local/bin/virtualenvwrapper.sh

## What Is /dev/shm And Its Practical Usage?
## https://www.cyberciti.biz/tips/what-is-devshm-and-its-practical-usage.html


## AI Top Level Directories
local AI_CFG_BASE_PATH="${AI_CODE_BASE_PATH}/cfg"
local AI_DATA_BASE_PATH="/${AI_DIR_PREFIX}-dat"
local AI_MOUNT_BASE_PATH="/${AI_DIR_PREFIX}-mnt"
local AI_DOC_BASE_PATH="/${AI_DIR_PREFIX}-doc"
local AI_RPT_BASE_PATH="/${AI_DIR_PREFIX}-rpt"
local AI_KBANK_BASE_PATH="/${AI_DIR_PREFIX}-kbank"

## ----------IMP--------------------##
## This has to be changed manually, and aimldl.setup.sh needs to be executed again!
local AI_PYVER=3
local AI_PY_VENV_NAME="py_3-6-9_2019-12-21"

local AI_WSGIPythonPath="${AI_PY_VENV_NAME}/bin"
local AI_WSGIPythonHome="${AI_PY_VENV_NAME}/lib/python3.6/site-packages/"
## ---------------------------------##

local AI_DATA_GAZE="/aimldl-dat/data-gaze"
local AI_ANNON_DATA_HOME="/data/samba/Bangalore/prod/Bangalore_Maze_Exported_Data/ANNOTATIONS"
local AI_ANNON_DB="/aimldl-dat/data-gaze/AIML_Database"
local AI_ANNON_DB_TEST="/aimldl-dat/data-gaze/AIML_Database_Test"
local AI_AIDS_DB="/aimldl-dat/data-gaze/AIML_Aids"
# local AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation"
# local AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/*/annotations"
# local AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719"
local AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_290719"
local AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_240919_121321"
local AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719"
# local AI_ANNON_DATA_HOME="${AI_ANNON_DATA_HOME_LOCAL}"

## Inspired by:
## https://github.com/ApolloAuto/apollo/tree/master/scripts

## absoulte path will always be /aimldl-dat
local AI_WEIGHTS_PATH="release" ## default value for production/CBR release

## uncomment and give custom relative path for model - should be used for development work
# local AI_WEIGHTS_PATH="logs"
