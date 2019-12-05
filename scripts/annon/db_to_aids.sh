#!/bin/bash

##----------------------------------------------------------
### Run single item
## created on 20th-Jun-2019
#
## Process the given single annotation file
##----------------------------------------------------------
## Usage:
#
## source db_to_aids.sh create <by> <did> 1>$(pwd)/logs/db_to_aids-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
##----------------------------------------------------------

echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

# source "${SCRIPTS_DIR}/config.sh"
# source "${SCRIPTS_DIR}/config.custom.sh"

function db_to_aids() {
  local cmd=$1
  local by=$2
  local did=$3

  echo "$1, $2, $3"

  if [ -z ${cmd} ]; then
    echo "cmd is missing!"
    return
  fi

  if [ -z ${by} ]; then
    echo "by (developer id) is missing!"
    return
  fi

  if [ -z ${did} ]; then
    echo "did (dataset id) is missing!"
    return
  fi

  local base_log_dir=${AI_LOGS}/annon
  mkdir -p ${base_log_dir}

  ## TODO: if previous command fails terminate
  local pyver=3
  local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
  workon ${pyenv}

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  
  local prog="${AI_ANNON_HOME}/db_to_aids.py"
  local prog_log="${base_log_dir}/db_to_aids-${cmd}.output-${timestamp}.log"
  
  echo "python ${prog} ${cmd} --by ${by} --did ${did} 1>${prog_log} 2>&1 &"
  python ${prog} ${cmd} --by ${by} --did ${did} 1>${prog_log} 2>&1 &
  echo "Log file: ${prog_log}"
}

db_to_aids $1 $2 $3

echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
