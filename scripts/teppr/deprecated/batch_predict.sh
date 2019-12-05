#!/bin/bash

##----------------------------------------------------------
### MASK_RCNN Predicting in Batch script
## created on 14th-May-2019
##----------------------------------------------------------
## Examples of commands to be executed in batch:
##----------------------------------------------------------
# 
## python main.py evaluate --arch cfg/arch/mask_rcnn-060519_115510.yml --dataset cfg/dataset/060519_115510.yml --path /home/prime/Documents/ai-ml-dl/sample-images/ --on train
## python main.py evaluate --arch cfg/arch/mask_rcnn-060519_115510.yml --dataset cfg/dataset/060519_115510.yml --path /home/prime/Documents/ai-ml-dl/sample-images/ --on train
## python main.py evaluate --arch cfg/arch/mask_rcnn-060519_115510.yml --dataset cfg/dataset/060519_115510.yml --path /home/prime/Documents/ai-ml-dl/sample-images/ --on train
## python main.py evaluate --arch cfg/arch/mask_rcnn-060519_115510.yml --dataset cfg/dataset/060519_115510.yml --path /home/prime/Documents/ai-ml-dl/sample-images/ --on train
## python main.py evaluate --arch cfg/arch/mask_rcnn-060519_115510.yml --dataset cfg/dataset/060519_115510.yml --path /home/prime/Documents/ai-ml-dl/sample-images/ --on train
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


## user input
## ip='69'
ip=$1
if [ -z $1 ]; then
  echo "IP is missing!"
  return
fi

# dataset_cfg_id=100519_112427
dataset_cfg_id=$2
if [ -z $2 ]; then
  echo "dataset_cfg_id is missing!"
  return
fi

if [ -z $AI_APP ]; then
  echo "AI_APP env path is missing!"
  return
fi

batch_execution_start_time=$(date)
prog=$AI_APP/falcon/main.py
arch=mask_rcnn
log_base_path=$AI_LOGS/$arch

cmd=predict
dbname=hmd

sample_img_path=$AI_HOME/sample-images
cfg_base_path=$AI_APP/falcon/cfg

echo "batch_execution_start_time: $batch_execution_start_time"
echo "ip: $ip"
echo "dataset_cfg_id is: $dataset_cfg_id"
echo "cmd: $cmd"
echo "dbname: $dbname"

pyver=3
pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
echo "change the pyenv to this: $pyenv"

## Kill the exisiting script pids
workon $pyenv

## For the loop
for i in {1..1}
do
  experiment_id=$i
  timestamp=$(date -d now +'%d%m%y_%H%M%S')
  # arch_cfg=$cfg_base_path/arch/$arch-$dataset_cfg_id'_'$ip'_'$experiment_id.yml
  arch_cfg=$arch-$dataset_cfg_id-$ip-$experiment_id.yml
  arch_cfg_path=$cfg_base_path/arch/$arch_cfg
  
  prog_output_log=$log_base_path/$cmd'_'$dbname'_'$dataset_cfg_id-$ip-$experiment_id.output-$timestamp.log
  prog_error_log=$log_base_path/$cmd'_'$dbname'_'$dataset_cfg_id-$ip-$experiment_id.error-$timestamp.log

  echo "Log timestamp: $timestamp"
  echo "arch_cfg_path: $arch_cfg_path"
  echo "prog_output_log: $prog_output_log"
  echo "prog_error_log: $prog_error_log"

  ## Execute Python
  python $prog $cmd --arch $arch_cfg_path --path $sample_img_path 1>$prog_output_log 2>$prog_error_log  
  ## Not sure if we need nohup
  ## nohub python $prog $cmd --dataset $dataset_cfg --arch $arch_cfg_path 1>$prog_output_log 2>$prog_error_log &

  ## Kill exisiting python programs before starting new
  pids=$(pgrep -f $prog)
  echo "Killed : $arch_cfg_path "
  echo "These $prog pids will be killed: $pids"
  pkill -f $prog

## 
done

batch_execution_end_time=$(date)
echo "batch_execution_end_time: $batch_execution_end_time"
