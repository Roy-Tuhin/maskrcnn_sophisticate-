#!/bin/bash

## usage
# enter orientation manually
# source batch_train_evaluate.sh vLine 1>${AI_LOGS}/lanenet/batch/batch_train_evaluate-$(date -d now +'%d%m%y_%H%M%S').log 2>&1

export __RUN_BATCH_CMD_COUNT__=0

function run_batch_train_evaluate(){
  echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

  source "${SCRIPTS_DIR}/lscripts/utils/common.sh"
  source batch_train_evaluate_cfg.sh
  source batch_train_evaluate_workload.sh
  cd ${AI_LANENET_ROOT}

  workon ${pyenv}

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')

  for config in "${configs[@]}"; do

    ##-----------Train
    local prog_log=$base_log_dir/train/lanenet-$timestamp.log
    info "Executing this command... train"
    info "Log file: ${prog_log}"

    echo "python ${prog_train} --cfg ${config} 1>$prog_log 2>&1"
    python ${prog_train} --cfg ${config} 1>$prog_log 2>&1

    local pids=$(pgrep -f ${prog_train})
    info "These ${prog_train} pids will be killed: ${pids}"
    pkill -f ${prog_train}

    local ckpt_path=$(ls -t ${ckpt_basepath} | head -n 1) 
    local ckpt=$(ls -t ${ckpt_basepath}/${ckpt_path} | head -1 | cut -d. -f1-2) 

    local model=${ckpt_basepath}/${ckpt_path}/${ckpt}
    info "Model to be evaluated on: ${model}"
    echo "sed -i 's:EVALUATE_MODEL_INFO:${model}/g' ${config}"
    sed -i "s:EVALUATE_MODEL_INFO:${model}:g" ${config}

    #-----------Evaluate
    info "Executing this command... evaluate"

    echo "python ${prog_evaluate} evaluate --cfg ${config} --orientation ${orientation}" 
    python ${prog_evaluate} evaluate --cfg ${config} --orientation ${orientation}

    ## Kill exisiting python programs before starting new
    local pids=$(pgrep -f ${prog_evaluate})
    info "These ${prog_evaluate} pids will be killed: ${pids}"
    pkill -f ${prog_evaluate}

    info "===x==x==x==="
  done

  local execution_end_time=$(date)
  info "execution_end_time: ${execution_end_time}"
  # info "summary_filepath: ${summary_filepath}"
  echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
}

orientation=$1
if [ -z $orientation ]; then
  echo "orientation is missing!"
  return
fi

run_batch_train_evaluate $orientation
