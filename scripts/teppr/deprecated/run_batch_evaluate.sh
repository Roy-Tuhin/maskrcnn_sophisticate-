#!/bin/bash

##----------------------------------------------------------
### Run batch script
## created on 16th-May-2019
##----------------------------------------------------------
## Usage:
#
## source run_batch_evaluate.sh 1>$HOME/Documents/ai-ml-dl-data/logs/mask_rcnn/run_batch_evaluate-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
## https://stackoverflow.com/questions/39267836/create-an-array-with-a-sequence-of-numbers-in-bash
## declare -a ious=($(seq 0.50 0.05 0.95))
#
##----------------------------------------------------------

source batch_evaluate_cfg.sh
source batch_workload_evaluate.sh

export __RUN_BATCH_EVALUATE_COUNT__=0
timestamp_batch=$(date -d now +'%d%m%y_%H%M%S')
base_log_dir='run_batch_evaluate-'$timestamp_batch
echo "base_log_dir: $base_log_dir"

for iou in "${ious[@]}"; do
  echo -e '\e[1;32m'":----> $ip $dataset_cfgs $iou"'\e[0m'
  for dataset_cfg_id in "${dataset_cfgs[@]}"; do
    echo "batch_evaluate.sh $dataset_cfg_id $experiment_ids $ip $timestamp_batch $base_log_dir $iou"
    source batch_evaluate.sh $dataset_cfg_id $experiment_ids $ip $iou $timestamp_batch $base_log_dir
  done
done
