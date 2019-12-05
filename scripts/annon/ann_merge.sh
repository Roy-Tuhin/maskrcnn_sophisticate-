#!/bin/bash

##----------------------------------------------------------
### Merge all the annotation jobs
## created on 05th-Jul-2019
##----------------------------------------------------------
## Usage:
#
## source ann_merge.sh 1>$(pwd)/logs/exec_annon_to_db-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
##----------------------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

# source "${SCRIPTS_DIR}/config.sh"
# source "${SCRIPTS_DIR}/config.custom.sh"

## Assuming the from path is mounted or has required directory structure
function ann_merge() {
  local base_log_dir=${AI_LOGS}/annon
  mkdir -p ${base_log_dir}

  ## TODO: if previous command fails terminate
  local pyver=3
  local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
  workon ${pyenv}

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')

  local prog="${AI_ANNON_HOME}/ann_merge.py"
  local prog_log="${base_log_dir}/ann_merge.output-${timestamp}.log"

  # from="/aimldl-mnt/vtq-samba-100/AIML_Annotation"
  # to="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_${timestamp}"

  from="/aimldl-dat/temp/"
  to="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_${timestamp}"

  mkdir -p ${to}

  echo "python ${prog} --from ${from} --to ${to} 1>$prog_log 2>&1"
  python ${prog} --from ${from} --to ${to} 1>$prog_log 2>&1
}

ann_merge
