#!/bin/bash


export __RUN_BATCH_CMD_COUNT__=0

function run_batch_train_evaluate(){
  echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

  source "${SCRIPTS_DIR}/lscripts/utils/common.sh"
  source batch_train_evaluate_cfg.sh
  source batch_train_evaluate_workload.sh

  workon ${pyenv}

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')

  for dataset in "${datasets[@]}"; do

    local timestamp_job_create_start=$(date -d now +'%d%m%y_%H%M%S')

    ## TODO: careful: somehow working, but not sure why single quotes to be there
    timestamp=$(date -d now +'%d%m%y_%H%M%S')

    prog_log=$log_base_path/train/lanenet-$timestamp.log 2>&1

    ##-----------Train
    info "Executing this command... train"
    info "Log file: ${prog_log}"

    ## Uncomment if training is required
    echo "python ${prog_train} --dataset ${dataset_path} --weights_path ${pre_trained_model} -m 0 1>$prog_log"
    python ${prog_train} --dataset ${dataset_path} --weights_path ${pre_trained_model} -m 0 1>$prog_log


    ## To ensure no dummy prog running
    pids=$(pgrep -f ${prog_train})
    info "These ${prog_train} pids will be killed: ${pids}"
    pkill -f ${prog_train}

    model_path 



    ##-----------Evaluate
    for eval_on in "${on_param[@]}"; do

      info "Executing this command... evaluate"

      info "python ${prog_evaluate} evaluate --dataset_dir ${aids_db_name} --weights_path ${weights_path} 
      # python ${prog_falcon} evaluate --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid_evaluate} 1>${evaluate_prog_log} 2>&1

      info "===x==x==x==="

      ## Kill exisiting python programs before starting new
      pids=$(pgrep -f ${prog_evaluate})
      info "These ${prog_evaluate} pids will be killed: ${pids}"
      pkill -f ${prog_evaluate}
    done

  done

  execution_end_time=$(date)
  info "execution_end_time: ${execution_end_time}"
  info "summary_filepath: ${summary_filepath}"
  echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
}

run_batch_train_evaluate
