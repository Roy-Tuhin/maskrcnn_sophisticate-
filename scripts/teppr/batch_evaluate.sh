#!/bin/bash

### Usage:

# source batch_evaluate.sh 1>${AI_LOGS}/mask_rcnn/batch_evaluate-$(date -d now +'%d%m%y_%H%M%S').log 2>&1

## To re-initialize the counter on the same terminal
export __RUN_BATCH_CMD_COUNT__=0

echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

function run_evaluate() {
  source "${SCRIPTS_DIR}/lscripts/utils/common.sh"
  source batch_evaluate_cfg.sh

  info ${pyenv}
  workon ${pyenv}

  for eval_on in "${on_param[@]}"; do
    index=-1
    for expid_evaluate in "${experiment_ids[@]}"; do
      index=$(( index + 1 ))
      timestamp=$(date -d now +'%d%m%y_%H%M%S')
      aids_db_name=${aids_dbs[${index}]}
      prog_log="${base_log_dir}/${cmd}_$(echo ${iou} | replace '.' '')-${eval_on}-${aids_db_name}-${timestamp}.log"
      # prog_log="${base_log_dir}/${cmd}-${eval_on}-${aids_db_name}-${timestamp}.log"

      info "Executing this command...${cmd}"
      info "Log file: ${prog_log}"
      info "${index},${eval_on},${aids_db_name}"

      info "sno,count,uuid,cmd,eval_on,username,aids_db_name,expid_evaluate,prog_log,iou,rpt_imagelist_filepath,rpt_metric_filepath,rpt_summary_filepath"
      info "$__RUN_BATCH_CMD_COUNT__,${index},${uuid},'evaluate',${eval_on},${username},${aids_db_name},${expid_evaluate},${prog_log},${iou},${rpt_imagelist_filepath},${rpt_metric_filepath},${rpt_summary_filepath}"

      ## no_viz
      info "python ${prog} ${cmd} --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid_evaluate} 1>${prog_log} 2>&1"
      python ${prog} ${cmd} --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid_evaluate} 1>${prog_log} 2>&1

      if [ -f ${prog_log} ]; then
        rpt_imagelist_filepath=$(grep "EVALUATE_REPORT:IMAGELIST" ${prog_log} | cut -d':' -f3)
        rpt_metric_filepath=$(grep "EVALUATE_REPORT:METRIC" ${prog_log} | cut -d':' -f3)
        rpt_summary_filepath=$(grep "EVALUATE_REPORT:SUMMARY" ${prog_log} | cut -d':' -f3)
      fi

      export __RUN_BATCH_CMD_COUNT__=$(($__RUN_BATCH_CMD_COUNT__+1))
      echo "$__RUN_BATCH_CMD_COUNT__,${index},${uuid},'evaluate',${eval_on},${username},${aids_db_name},${expid_evaluate},${prog_log},${iou},${rpt_imagelist_filepath},${rpt_metric_filepath},${rpt_summary_filepath}" >> ${summary_filepath}

      info "===x==x==x==="

      ## Kill exisiting python programs before starting new
      pids=$(pgrep -f ${prog})
      info "These ${prog} pids will be killed: ${pids}"
      pkill -f ${prog}
    done
  done
}

run_evaluate

execution_end_time=$(date)

info "summary_filepath: ${summary_filepath}"
info "execution_end_time: ${execution_end_time}"

echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
