#!/bin/bash

##----------------------------------------------------------
### demo
##----------------------------------------------------------

SCRIPTS_DIR="$( cd  "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

function run_annon_demo() {
  local from_path="${SCRIPTS_DIR}/samples/AIML_Annotation/annotations"
  # annotationfile=""
  # from_path="${HOME}/Documents/aimldl/apps/annon/samples/AIML_Annotation/annotations/${annotationfile}"
  local annon_basepath="${SCRIPTS_DIR}/samples/AIML_Database"
  local aids_basepath="${SCRIPTS_DIR}/samples/AIML_Aids"
  local aids_cfg_basepath="${SCRIPTS_DIR}/samples/AIML_Cfg/dataset"

  local prog="annon.py"
  local cmd="create"
  python ${prog} ${cmd} --from ${from_path} --anndb ${annon_basepath} --aids ${aids_basepath} --cfg ${aids_cfg_basepath}
}

run_annon_demo