
#!/bin/bash

##----------------------------------------------------------
### Run single item
## created on 18th-Jul-2019
#
## Process the given cfg file
##----------------------------------------------------------
## Usage:
#
## source teppr.sh <cmd> <type> <from> <to> 1>$(pwd)/logs/teppr-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
##----------------------------------------------------------

function teppr() {
  local cmd=$1
  local type=$2
  local from=$3
  local to=$4

  echo "$1, $2, $3, $4"

  if [ -z ${cmd} ]; then
    echo "cmd is missing!"
    return
  fi

  if [ -z ${type} ]; then
    echo "type is missing!"
    return
  fi

  if [ -z ${from} ]; then
    echo "from is missing!"
    return
  fi

  if [ -z ${to} ]; then
    echo "to is missing!"
    return
  fi

  local base_log_dir=${AI_LOGS}/annon
  mkdir -p ${base_log_dir}

  ## TODO: if previous command fails terminate
  local pyver=3
  local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
  workon ${pyenv}

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  
  local prog="${AI_ANNON_HOME}/teppr.py"
  local prog_log="${base_log_dir}/teppr-${type}.output-${timestamp}.log"

  # python teppr.py create --type modelinfo --from /aimldl-cfg/model/vidteq-tsdr-1-mask_rcnn.yml --to annon_v3

  echo "python ${prog} ${cmd} --from ${from} --to ${to}"
  python ${prog} ${cmd} --type ${type} --from ${from} --to ${to} 1>$prog_log 2>&1
}

teppr $1 $2 $3 $4
