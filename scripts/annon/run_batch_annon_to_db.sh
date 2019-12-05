#!/bin/bash

##----------------------------------------------------------
### Run batch script
## created on 20th-Jun-2019
#
## Process all the annotation files one by one in a given annotation directory
##----------------------------------------------------------
## Usage:
#
## source run_batch_annon_to_db.sh 1>$(pwd)/logs/run_batch_annon_to_db-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
##----------------------------------------------------------


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

# source "${SCRIPTS_DIR}/config.sh"
# source "${SCRIPTS_DIR}/config.custom.sh"

function run_batch_annon_to_db() {
  local timestamp_batch=$(date -d now +'%d%m%y_%H%M%S')
  local cmd="create"
  declare -a array=($(ls -d ${AI_ANNON_DATA_HOME}))

  for d in "${array[@]}"; do
    echo ""
    echo "##----------------------------------------------------------"
    echo "$d"
    source annon_to_db.sh ${cmd} ${d} ${AI_ANNON_DB}
    echo "##----------------------------------------------------------"
    echo ""
  done
}

run_batch_annon_to_db
