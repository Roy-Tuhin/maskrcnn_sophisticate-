#!/bin/bash

##----------------------------------------------------------
### Run batch script
## created on 16th-May-2019
##----------------------------------------------------------
## Usage:
#
## source run_batch_train.sh 1>${AI_LOGS}/run_batch_train-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------
## References:
#
## https://stackoverflow.com/questions/39267836/create-an-array-with-a-sequence-of-numbers-in-bash
## declare -a ious=($(seq 0.50 0.05 0.95))
#
##----------------------------------------------------------

source batch_train_cfg.sh
source batch_workload_train.sh

export __RUN_BATCH_TRAIN_COUNT__=0
timestamp_batch=$(date -d now +'%d%m%y_%H%M%S')
base_log_dir='run_batch_train-'$timestamp_batch
echo "base_log_dir: $base_log_dir"

for dataset_cfg_id in "${dataset_cfgs[@]}"; do
  echo -e '\e[1;32m'":----> $ip $dataset_cfg_id"'\e[0m'
  source batch_train.sh $dataset_cfg_id $experiment_ids $ip $timestamp_batch $base_log_dir
done
