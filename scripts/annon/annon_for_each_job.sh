#!/bin/bash

##----------------------------------------------------------
### Run single item
## created on 28th-Nov-2019
#
## Create annon for each job ids
##----------------------------------------------------------
## Usage:
#
## source annon_for_each_job.sh 1>${AI_LOGS}/annon/annon_for_each_job-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
##----------------------------------------------------------

echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

function create_annon_for_each_job() {
  local base_log_dir=${AI_LOGS}/annon
  mkdir -p ${base_log_dir}

  ## TODO: if previous command fails terminate
  local pyver=3
  local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
  workon ${pyenv}

  local cfgfile=_annoncfg_.py
  local cfgfile_basepath='/aimldl-cod/apps/annon'

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  local cfg_filepath=${cfgfile_basepath}/${cfgfile}
  local cfgbkup_filepath=${cfgfile_basepath}/${cfgfile}.${timestamp}

  echo "Creating backup: cp  ${cfg_filepath} ${cfgbkup_filepath}"

  # cp  ${cfg_filepath} ${cfgbkup_filepath}

  local annon_job_basepath=/aimldl-dat/data-gaze/AIML_Annotation/ods_selected_jobs
  local total_jobs=$(ls ${annon_job_basepath} | wc -l)

  local annon_frompaths_str=$(ls -dm ${annon_job_basepath}/*/annotations)
  local annon_frompaths_arr=(${annon_frompaths_str//,/ })

  local prog_annon_to_db=${AI_ANNON_HOME}/annon_to_db.py
  local prog_db_to_aids=${AI_ANNON_HOME}/db_to_aids.py
  local prog_teppr=${AI_ANNON_HOME}/teppr.py


  ## For vidteq-hmd-1-mask_rcnn.yml
  local archcfg="/aimldl-cfg/arch/281119_123250-AIE1-21-mask_rcnn.yml"

  local annon_labels_str="traffic_sign,signage,traffic_light"

  ## change it manually everytime based on the previous value
  local annon_prev=4

  echo "annon_prev: ${annon_prev}"
  echo "Total jobs: ${#annon_frompaths_arr[@]}"

  local count=0
  for annon_frompath in "${annon_frompaths_arr[@]}"; do
    count=$((count + 1))

    local annon_dbname=annon_v$((annon_prev+count))
    local timestamp_job_create_start=$(date -d now +'%d%m%y_%H%M%S')
    local prog_annon_to_db_log="${base_log_dir}/annon_to_db-create.output-${timestamp_job_create_start}.log"

    echo 's/annon_v[0-9]*/'${annon_dbname}'/g' ${cfg_filepath}
    echo "${prog_annon_to_db} create --from ${annon_frompath}"
    echo "Creating Annon, executing annon_to_db for: ${annon_dbname}"

    sed -i 's/annon_v[0-9]*/'${annon_dbname}'/g' ${cfg_filepath}
    python ${prog_annon_to_db} create --from ${annon_frompath} 1>${prog_annon_to_db_log} 2>&1

    local prog_db_to_aids_log="${base_log_dir}/db_to_aids-create-${annon_dbname}.output-${timestamp}.log"

    echo "Creating AIDS, executing db_to_aids for: ${annon_dbname}"
    echo "${prog_db_to_aids} create --by AIE1 --did hmd --labels ${annon_labels_str} 1>${prog_db_to_aids_log} 2>&1"
    python ${prog_db_to_aids} create --by AIE1 --did hmd --labels ${annon_labels_str} 1>${prog_db_to_aids_log} 2>&1

    local aids_db_name=$(grep "AIDS(AI Dataset):" ${prog_db_to_aids_log} | rev | cut -d' ' -f1 | rev)
    echo "${annon_dbname},${aids_db_name},${annon_labels_str}"

    ## create experiment
    python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp train 1>>${prog_db_to_aids_log} 2>&1

    local expid=$(grep "CFG(Annotation Database) res:" ${prog_db_to_aids_log} | rev | cut -d' ' -f1 | rev)
    echo "${annon_dbname},${aids_db_name},${annon_labels_str},${expid}"
  done
}

create_annon_for_each_job

echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
