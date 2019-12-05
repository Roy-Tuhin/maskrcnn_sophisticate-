#!/bin/bash


export __RUN_BATCH_CMD_COUNT__=0

function run_batch_train_evaluate(){
  echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

  source "${SCRIPTS_DIR}/common.sh"
  source batch_train_evaluate_cfg.sh

  workon ${pyenv}

  local pids=""
  local cfgfile=appcfg.py
  local cfgfile_basepath='/aimldl-cod/scripts'

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')

  local cfg_filepath=${cfgfile_basepath}/${cfgfile}
  local cfgbkup_filepath=${cfgfile_basepath}/${cfgfile}.${timestamp}

  echo "Creating backup: cp  ${cfg_filepath} ${cfgbkup_filepath}"
  cp  ${cfg_filepath} ${cfgbkup_filepath}

  # local annon_job_basepath=/aimldl-dat/data-gaze/AIML_Annotation/ods_selected_jobs
  # local annon_frompaths_str=$(ls -dm ${annon_job_basepath}/*/annotations)
  # local annon_frompaths_arr=(${annon_frompaths_str//,/ })

  declare -a no_of_dbs=($(seq 1 1 4)) ## 4 items

  local annon_prev=4
  echo "annon_prev: ${annon_prev}"

  local count=0
  local index=-1
  for item_num in "${no_of_dbs[@]}"; do
    count=$((count + 1))
    index=$(( index + 1 ))

    local annon_dbname=annon_v$((annon_prev+count))
    local timestamp_job_create_start=$(date -d now +'%d%m%y_%H%M%S')

    ## TODO: careful: somehow working, but not sure why single quotes to be there
    echo 's/annon_v[0-9]*/'${annon_dbname}'/g' ${cfg_filepath}
    sed -i 's/annon_v[0-9]*/'${annon_dbname}'/g' ${cfg_filepath}

    timestamp=$(date -d now +'%d%m%y_%H%M%S')

    expid=${experiment_ids[${index}]}
    aids_db_name=${aids_dbs[${index}]}

    prog_log="${base_log_dir}/train.output-${timestamp}.log"
    # prog_log="${base_log_dir}/${train_logs[${index}]}"

    ##-----------Train
    info "Executing this command...train"
    info "Log file: ${prog_log}"

    ## Uncomment if training is required
    echo "python ${prog_falcon} train --dataset ${aids_db_name} --exp ${expid} 1>${prog_log} 2>&1"
    python ${prog_falcon} train --dataset ${aids_db_name} --exp ${expid} 1>${prog_log} 2>&1

    # local modelinfo_file = $(grep -oE -m 1 "vidteq-hmd-"[0-9]*_[0-9]*"-mask_rcnn.yml" ${prog_log})
    local modelinfo_file=$(grep -oE "TRAIN:MODELINFO_FILEPATH: .*$" ${prog_log} | cut -d' ' -f2 | rev | cut -d'/' -f1 | rev)
    info "modelinfo_file: ${modelinfo_file}"
    echo "sed -i 's/EVALUATE_MODEL_INFO/${modelinfo_file}/g' ${archcfg}"
    sed -i "s/EVALUATE_MODEL_INFO/${modelinfo_file}/g" ${archcfg}

    ## To ensure no dummy prog running
    pids=$(pgrep -f ${prog_falcon})
    info "These ${prog_falcon} pids will be killed: ${pids}"
    pkill -f ${prog_falcon}

    echo "python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp evaluate 1>>${prog_log} 2>&1"
    python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp evaluate 1>>${prog_log} 2>&1

    local expid_evaluate=$(grep "CFG(Annotation Database) res:" ${prog_log} | rev | cut -d' ' -f1 | rev | tail -n 1)

    info "sno,count,uuid,cmd,eval_on,username,aids_db_name,expid,prog_log,iou,rpt_imagelist_filepath,rpt_metric_filepath,rpt_summary_filepath"
    info "$__RUN_BATCH_CMD_COUNT__,${index},${uuid},'train',,${username},${aids_db_name},${expid},${prog_log},,,,"

    export __RUN_BATCH_CMD_COUNT__=$(($__RUN_BATCH_CMD_COUNT__+1))
    echo "$__RUN_BATCH_CMD_COUNT__,${index},${uuid},'train',,${username},${aids_db_name},${expid},${prog_log},,,," >> ${summary_filepath}

    ##-----------Evaluate
    for eval_on in "${on_param[@]}"; do
      evaluate_prog_log="${base_log_dir}/evaluate_$(echo ${iou} | replace '.' '')-${eval_on}-${aids_db_name}-${timestamp}.log"

      info "Executing this command...evaluate"
      info "Log file: ${evaluate_prog_log}"
      info "${index},${eval_on},${aids_db_name}"

      info "python ${prog_falcon} evaluate --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid_evaluate} 1>${evaluate_prog_log} 2>&1"
      python ${prog_falcon} evaluate --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid_evaluate} 1>${evaluate_prog_log} 2>&1

      if [ -f ${evaluate_prog_log} ]; then
        rpt_imagelist_filepath=$(grep "EVALUATE_REPORT:IMAGELIST" ${evaluate_prog_log} | cut -d':' -f3)
        rpt_metric_filepath=$(grep "EVALUATE_REPORT:METRIC" ${evaluate_prog_log} | cut -d':' -f3)
        rpt_summary_filepath=$(grep "EVALUATE_REPORT:SUMMARY" ${evaluate_prog_log} | cut -d':' -f3)
      fi

      export __RUN_BATCH_CMD_COUNT__=$(($__RUN_BATCH_CMD_COUNT__+1))
      echo "$__RUN_BATCH_CMD_COUNT__,${index},${uuid},'evaluate',${eval_on},${username},${aids_db_name},${expid_evaluate},${prog_log},${iou},${rpt_imagelist_filepath},${rpt_metric_filepath},${rpt_summary_filepath}" >> ${summary_filepath}

      info "===x==x==x==="

      ## Kill exisiting python programs before starting new
      pids=$(pgrep -f ${prog_falcon})
      info "These ${prog_falcon} pids will be killed: ${pids}"
      pkill -f ${prog_falcon}
    done

    ## re-set to key, so it can be re-placed in next iteration
    sed -i "s/${modelinfo_file}/EVALUATE_MODEL_INFO/g" ${archcfg}
  done

  execution_end_time=$(date)
  info "execution_end_time: ${execution_end_time}"
  info "summary_filepath: ${summary_filepath}"
  echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
}

run_batch_train_evaluate
