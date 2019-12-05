#!/bin/bash

##----------------------------------------------------------
### Run batch script
## created on 20th-Jun-2019
#
## Process all the annotation files one by one in a given annotation directory
##----------------------------------------------------------
## Usage:
#
## source run_release_modelinfo.sh <annon_db_name> 1>${AI_LOGS}/run_release_modelinfo-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
## Get all the files in a given path with the absolute path
## https://stackoverflow.com/questions/27340307/list-file-using-ls-command-in-linux-with-full-path/36449348#36449348
#
##----------------------------------------------------------


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

# source "${SCRIPTS_DIR}/config.sh"
# source "${SCRIPTS_DIR}/config.custom.sh"

function run_release_modelinfo() {
  local cmd="create"
  local type="modelinfo"
  local to=$1

  if [ -z ${to} ]; then
    echo "to is missing!"
    return
  fi

  local timestamp_batch=$(date -d now +'%d%m%y_%H%M%S')
  declare -a array=($(ls -d -1 ${AI_CFG}/model/release/*.*))

  for from in "${array[@]}"; do
    echo ""
    echo "##----------------------------------------------------------"
    echo "${from}"
    source teppr.sh ${cmd} ${type} ${from} ${to}
    echo "##----------------------------------------------------------"
    echo ""
  done
}

run_release_modelinfo $1
