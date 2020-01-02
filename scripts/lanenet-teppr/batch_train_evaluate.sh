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

    timestamp=$(date -d now +'%d%m%y_%H%M%S')
    dataset_train=${AI_AIDS_DB}/${dataset}/training


    ##-----------Train
    prog_log=$base_log_dir/train/lanenet-$timestamp.log
    info "Executing this command... train"
    info "Log file: ${prog_log}"

    echo "python ${prog_train} --net vgg --dataset ${dataset_train} --weights_path ${pre_trained_model} -m 0 1>$prog_log 2>&1"
    # python ${prog_train} --net vgg --dataset ${dataset_train} --weights_path ${pre_trained_model} -m 0 1>$prog_log 2>&1


    pids=$(pgrep -f ${prog_train})
    info "These ${prog_train} pids will be killed: ${pids}"
    pkill -f ${prog_train}

    ckpt_path=$(ls -td ${ckpt_basepath}* | head -n 1) 
    ckpt=$(ls -t ${ckpt_path} | head -1 | cut -d. -f1-2 ) 

    model=${ckpt_path}/${ckpt}

    dataset_eval=$(ls ${AI_AIDS_DB}/${dataset}/testing/)
    dataset_eval_path=${AI_AIDS_DB}/${dataset}/testing/${dataset_eval}

    #-----------Evaluate
    info "Executing this command... evaluate"

    echo "python ${prog_evaluate} evaluate --src ${dataset_eval_path} --weights_path ${model}" 
    # python ${prog_evaluate} evaluate --src ${dataset_eval_path} --weights_path ${model}

    ## Kill exisiting python programs before starting new
    pids=$(pgrep -f ${prog_evaluate})
    info "These ${prog_evaluate} pids will be killed: ${pids}"
    pkill -f ${prog_evaluate}

    info "===x==x==x==="
  done

  execution_end_time=$(date)
  info "execution_end_time: ${execution_end_time}"
  # info "summary_filepath: ${summary_filepath}"
  echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'
}

run_batch_train_evaluate
