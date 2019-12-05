#!/bin/bash

##----------------------------------------------------------
### Run single item
## created on 20th-Jun-2019
#
## Process the given single annotation file
##----------------------------------------------------------
## Usage:
#
## source annon_to_db.sh create <from> <to> 1>$(pwd)/logs/annon_to_db-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
##----------------------------------------------------------

echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

# source "${SCRIPTS_DIR}/config.sh"
# source "${SCRIPTS_DIR}/config.custom.sh"

function annon_to_db() {
  local cmd=$1
  local from=$2
  local to=$3

  echo "$1, $2, $3"

  if [ -z ${cmd} ]; then
    echo "cmd is missing!"
    return
  fi

  if [ -z ${from} ]; then
    echo "from is missing!"
    return
  fi

  local base_log_dir=${AI_LOGS}/annon
  mkdir -p ${base_log_dir}

  ## TODO: if previous command fails terminate
  local pyver=3
  local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
  workon ${pyenv}

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  
  local prog="${AI_ANNON_HOME}/annon_to_db.py"
  local prog_log="${base_log_dir}/annon_to_db-${cmd}.output-${timestamp}.log"
  
  if [ -z ${to} ]; then
    echo "python ${prog} ${cmd} --from ${from} 1>${prog_log} 2>&1 &"
    python ${prog} ${cmd} --from ${from} 1>${prog_log} 2>&1 &
  else
    echo "python ${prog} ${cmd} --from ${from} --to ${to} 1>${prog_log} 2>&1 &"
    python ${prog} ${cmd} --from ${from} --to ${to} 1>${prog_log} 2>&1 &
  fi
}

annon_to_db $1 $2 $3

echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
