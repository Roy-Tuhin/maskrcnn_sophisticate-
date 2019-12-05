#!/bin/bash

##----------------------------------------------------------
### MASK_RCNN Training in Batch script
## created on 10th-May-2019
##----------------------------------------------------------
## Examples of commands to be executed in batch:
##----------------------------------------------------------
#
## python main.py train --dataset cfg/dataset/100519_112427.yml --arch cfg/arch/mask_rcnn-100519_112427_69_2.yml > /home/alpha/Documents/ai-ml-dl-data/logs/mask_rcnn/train_hmd_100519.69.2.log
#
##----------------------------------------------------------
## TODO:
##----------------------------------------------------------
#
##  1. Change pyenv script to handle multiple environment.
##     possibly take it as user input
##  2. Check for Environment variables, error if does not exists
#
##----------------------------------------------------------
## References:
##----------------------------------------------------------
#
##  * https://superuser.com/questions/941610/how-do-i-determine-the-pid-of-my-python-program-if-there-is-more-then-one-python
##    * Examples:
##      pgrep -f /home/alpha/Documents/ai-ml-dl/apps/falcon/main.py | wc -l
##      ps ax | grep 'python /home/alpha/Documents/ai-ml-dl/apps/falcon/main.py' | grep -v grep | awk '{print $1}' | wc -l
#
##----------------------------------------------------------


echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'

source batch_train_cfg.sh

## environment variables validation
if [ -z $AI_APP ]; then
  echo "AI_APP env path is missing!"
  return
fi

## user input validation

# dataset_cfg_id=100519_112427
dataset_cfg_id=$1
if [ -z $dataset_cfg_id ]; then
  echo "dataset_cfg_id is missing!"
  return
fi

experiment_ids=$2
if [ -z $experiment_ids ]; then
  return
fi

ip=$3
if [ -z $ip ]; then
  echo "IP is missing!"
  return
fi

timestamp_batch=$4
if [ -z $timestamp_batch ]; then
  timestamp_batch=$(date -d now +'%d%m%y_%H%M%S')
fi

base_log_dir=$5
if [ -z $base_log_dir ]; then
  base_log_dir='batch_train-'$timestamp_batch
fi


mkdir -p $log_base_path/$base_log_dir

## Assuming the dataset cfg has three split, or change this
## TODO:
## - make it automatic detection from the dataset cfg, or
## - user input along with the dataset file name is the simplest possible way
# declare -a on_param=(train val test)
declare -a on_param=(train)
dataset_cfg=$dataset_cfg_id.yml
dataset_cfg_path=$cfg_base_path/dataset/$dataset_cfg

train_file=train_data-$timestamp_batch.csv
train_filepath=$log_base_path/$base_log_dir/$train_file

train_file_header='sno,uuid,model,architecture,dataset,experiment_id,train_dir,status,username,remarks'

batch_execution_start_time=$(date)
pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
uuid=$(uuidgen)
username=$(whoami)

echo "batch_execution_start_time: $batch_execution_start_time"
echo "pyenv: $pyenv"

echo "__RUN_BATCH_TRAIN_COUNT__: $__RUN_BATCH_TRAIN_COUNT__"
echo "ip: $ip"
echo "cmd: $cmd"
echo "dbname: $dbname"
echo "dataset_cfg_id is: $dataset_cfg_id"
echo "dataset_cfg_path: $dataset_cfg_path"
echo "log_base_path: $log_base_path"
echo "train_filepath: $train_filepath"
echo "uuid: $uuid"
echo "username: $username"
echo "experiment_ids: $experiment_ids"

echo "-------"

if [ ! -f $train_filepath ]; then
  echo "train_filepath: $train_filepath"
  # ls -ltr $train_filepath
  echo $train_file_header > $train_filepath
  ls -ltr $train_filepath
fi

workon $pyenv

for i in "${experiment_ids[@]}"; do
  experiment_id=$i
  timestamp=$(date -d now +'%d%m%y_%H%M%S')
  arch_cfg=$arch-$dataset_cfg_id-$ip-$experiment_id.yml
  arch_cfg_path=$cfg_base_path/arch/$arch_cfg

  echo "experiment_id: timestamp: $experiment_id: $timestamp"
  echo "arch_cfg_path: $arch_cfg_path"

  echo "=========="

  prog_output_log=$log_base_path/$base_log_dir/$dataset_cfg_id-$cmd-$dbname-$ip-$experiment_id.output-$timestamp.log
  prog_error_log=$log_base_path/$base_log_dir/$dataset_cfg_id-$cmd-$dbname-$ip-$experiment_id.error-$timestamp.log

  echo "prog_output_log: $prog_output_log"
  echo "prog_error_log: $prog_error_log"

  python $prog $cmd --dataset $dataset_cfg_path --arch $arch_cfg_path 1>$prog_output_log 2>$prog_error_log

  ## header
  export __RUN_BATCH_TRAIN_COUNT__=$(($__RUN_BATCH_TRAIN_COUNT__+1))
  echo "$__RUN_BATCH_TRAIN_COUNT__,$uuid,MODEL,$arch_cfg,$dataset_cfg,$experiment_id,train_dir,done,$username,script_generated" >> $train_filepath
  # ### Not sure if we need nohup
  # ##nohup python $prog $cmd --dataset $dataset_cfg_path --arch $arch_cfg_path 1>$prog_output_log 2>$prog_error_log &

  echo "===x==x==x==="

  ## Kill exisiting python programs before starting new
  pids=$(pgrep -f $prog)
  echo "These $prog pids will be killed: $pids"
  pkill -f $prog

##
done
echo "-------"

batch_execution_end_time=$(date)
echo "batch_execution_end_time: $batch_execution_end_time"

echo -e '\e[0;31m'End Script: -------x-------x-------x-------'\e[0m'