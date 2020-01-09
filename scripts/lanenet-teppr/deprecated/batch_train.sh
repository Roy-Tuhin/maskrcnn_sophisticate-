#!/bin/bash

##----------------------------------------------------------
### Lanenet Training in Batch script
## created on 30th-Dec-2019
##----------------------------------------------------------
## Examples of commands to be executed in batch:
##----------------------------------------------------------
#
## python tools/train_lanenet.py --net vgg --weights_path <'path/to/last-checkpoint'> --dataset_dir /aimldl-dat/data-public/tusimple/train_set/training -m 0 1>/aimldl-dat/logs/lanenet/train/lanenet-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
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

## user input validation

# dataset=lnd-251119_114944
dataset=$1
if [ -z $dataset ]; then
  echo "dataset_cfg_id is missing!"
  return
fi

dataset_path=$AI_AIDS_DB/$dataset/training

batch_execution_start_time=$(date)
pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
uuid=$(uuidgen)
username=$(whoami)

echo "batch_execution_start_time: $batch_execution_start_time"
echo "pyenv: $pyenv"

echo "__RUN_BATCH_TRAIN_COUNT__: $__RUN_BATCH_TRAIN_COUNT__"
echo "log_base_path: $log_base_path"
echo "dataset_path: $dataset_path"

echo "-------"

workon $pyenv

timestamp=$(date -d now +'%d%m%y_%H%M%S')

prog_log=$log_base_path/train/lanenet-$timestamp.log 2>&1

# python $prog --net vgg --dataset $dataset_path --weights_path $pre_trained_model -m 0 1>$prog_log
echo $prog --net vgg --dataset $dataset_path --weights_path $pre_trained_model -m 0 1>$prog_log

## header
# ### Not sure if we need nohup
# ##nohup python $prog $cmd --dataset $dataset_cfg_path --arch $arch_cfg_path 1>$prog_output_log 2>$prog_error_log &

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