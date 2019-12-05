#!/bin/bash

##----------------------------------------------------------
### AIMLDL Batch script
## created on 10th-May-2019
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
## Commands to replace bulk or specific file:
## find . -iname '*.yml' -type f -exec sed -i 's/EVALUATE_NO_OF_RESULT: 3/EVALUATE_NO_OF_RESULT: -1/g' {} \;
## find . -iname 'mask_rcnn-140519_193751_69_5.yml' -type f -exec sed -i 's/EVALUATE_NO_OF_RESULT: 3/EVALUATE_NO_OF_RESULT: -1/g' {} \;
#
## UUID Generation
##  * https://unix.stackexchange.com/questions/500572/create-unique-random-numbers-uuids-in-bash
##  * uuidgen
##  * cat /proc/sys/kernel/random/uuid
#
## Grep (for arch cfg)
##--------
## find . -iname '*.yml' -type f -exec grep -inH --color='auto' 'SAVE_VIZ_AND_JSON: true' {} \;
## find . -iname '*.yml' -type f -exec grep -inH --color='auto' 'SAVE_VIZ_AND_JSON: true' {} \; | wc -l
#
## Sed (for arch cfg)
##--------
## find . -iname '*.yml' -type f -exec sed -i 's/SAVE_VIZ_AND_JSON: true/SAVE_VIZ_AND_JSON: false/g' {} \;
## find . -iname '*.yml' -type f -exec sed -i 's/SAVE_VIZ_AND_JSON: false/SAVE_VIZ_AND_JSON: true/g' {} \;
#
##----------------------------------------------------------
## Usage:
## 1. Refer and run through script: run_batch_evaluate.sh
## 2. Standalone execution:
## source batch_evaluate.sh $dataset_cfg_id $experiment_ids $ip $iou
#
## Example of standalone execution:
## export __RUN_BATCH_EVALUATE_COUNT__=0 && source batch_evaluate.sh 100519_112427 1 0.50 69 1>$HOME/Documents/ai-ml-dl-data/logs/mask_rcnn/batch_evaluate-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------

echo -e '\e[1;32m'Begin Script: -------------------------------'\e[0m'

source batch_evaluate_cfg.sh

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

iou=$4
if [ -z $iou ]; then
  echo "iou is missing!"
  return
fi

timestamp_batch=$5
if [ -z $timestamp_batch ]; then
  timestamp_batch=$(date -d now +'%d%m%y_%H%M%S')
fi

base_log_dir=$6
if [ -z $base_log_dir ]; then
  base_log_dir='batch_evaluate-'$timestamp_batch
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
evaluate_file=evaluate_data-$timestamp_batch.csv
evaluate_filepath=$log_base_path/$base_log_dir/$evaluate_file
evaluate_file_header='sno,uuid,model,architecture,dataset,iou,experiment_id,evaluate_on,evalaute_dir,status,username,remarks'
batch_execution_start_time=$(date)
pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
uuid=$(uuidgen)
username=$(whoami)

echo "batch_execution_start_time: $batch_execution_start_time"
echo "pyenv: $pyenv"

echo "__RUN_BATCH_EVALUATE_COUNT__: $__RUN_BATCH_EVALUATE_COUNT__"
echo "ip: $ip"
echo "cmd: $cmd"
echo "dbname: $dbname"
echo "dataset_cfg_id is: $dataset_cfg_id"
echo "dataset_cfg_path: $dataset_cfg_path"
echo "log_base_path: $log_base_path"
echo "evaluate_filepath: $evaluate_filepath"
echo "uuid: $uuid"
echo "username: $username"
echo "experiment_ids: $experiment_ids"

echo "-------"

if [ ! -f $evaluate_filepath ]; then
  echo "evaluate_filepath: $evaluate_filepath"
  # ls -ltr $evaluate_filepath
  echo $evaluate_file_header > $evaluate_filepath
  ls -ltr $evaluate_filepath
fi

workon $pyenv

for i in "${experiment_ids[@]}"; do
  experiment_id=$i
  timestamp=$(date -d now +'%d%m%y_%H%M%S')
  arch_cfg=$arch-$dataset_cfg_id-$ip-$experiment_id.yml
  # arch_cfg=$arch-$dataset_cfg_id.yml
  arch_cfg_path=$cfg_base_path/arch/$arch_cfg

  echo "experiment_id: timestamp: $experiment_id: $timestamp"
  echo "arch_cfg_path: $arch_cfg_path"

  ###evaluate_no_of_result="$(grep 'EVALUATE_NO_OF_RESULT' $arch_cfg_path | rev | cut -d':' -f1 | rev | xargs)"
  save_viz_and_json="$(grep -n 'SAVE_VIZ_AND_JSON' $arch_cfg_path)"
  evaluate_no_of_result="$(grep -n 'EVALUATE_NO_OF_RESULT' $arch_cfg_path)"
  echo -e '\e[0;31m'$evaluate_no_of_result'\e[0m'
  echo -e '\e[0;31m'$save_viz_and_json'\e[0m'
  echo "=========="

  for on in "${on_param[@]}"; do
    ## Execute Python
    # prog_output_log=$log_base_path/$base_log_dir/$cmd'-'$iou'_'$dbname'_'$dataset_cfg_id-$ip-$experiment_id-$on.output-$timestamp.log
    # prog_error_log=$log_base_path/$base_log_dir/$cmd'-'$iou'_'$dbname'_'$dataset_cfg_id-$ip-$experiment_id-$on.error-$timestamp.log


    prog_output_log=$log_base_path/$base_log_dir/$dataset_cfg_id-$cmd'_'$(echo $iou | replace '.' '')-$dbname-$on-$ip-$experiment_id.output-$timestamp.log
    prog_error_log=$log_base_path/$base_log_dir/$dataset_cfg_id-$cmd'_'$(echo $iou | replace '.' '')-$dbname-$on-$ip-$experiment_id.error-$timestamp.log

    echo "prog_output_log: $prog_output_log"
    echo "prog_error_log: $prog_error_log"

    python $prog $cmd --dataset $dataset_cfg_path --arch $arch_cfg_path --on $on --iou $iou 1>$prog_output_log 2>$prog_error_log

    ## header
    export __RUN_BATCH_EVALUATE_COUNT__=$(($__RUN_BATCH_EVALUATE_COUNT__+1))
    echo "$__RUN_BATCH_EVALUATE_COUNT__,$uuid,MODEL,$arch_cfg,$dataset_cfg,$iou,$experiment_id,$on,evalaute_dir,done,$username,script_generated" >> $evaluate_filepath
    # ### Not sure if we need nohup
    # ##nohup python $prog $cmd --dataset $dataset_cfg_path --arch $arch_cfg_path --on $on --iou 0.5 1>$prog_output_log 2>$prog_error_log &
  done
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