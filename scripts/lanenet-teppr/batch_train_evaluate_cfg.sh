#!/bin/bash

timestamp_start=$(date -d now +'%d%m%y_%H%M%S')
execution_start_time=$(date)

arch=lanenet

prog_train=$AI_LANENET_ROOT/tools/train_lanenet.py
prog_evaluate=$AI_LANENET_ROOT/tools/predict.py

base_log_dir=${AI_LOGS}/${arch}
ckpt_basepath=${base_log_dir}/model/

uuid=$(uuidgen)
username=$(whoami)

pyver=3
pyenv=$(lsvirtualenv -b | grep ^py_${pyver} | tr '\n' ',' | cut -d',' -f1)

cmd=evaluate

summary_file=${cmd}-${arch}.csv
summary_filepath=${base_log_dir}/${summary_file}


##----------------------------------------------------------
### AI Workload for single run or batch
##----------------------------------------------------------

## this iou is only used to visualize the data if save_viz flag is enabled, but its mandatory to pass this option for now
# iou=0.50

declare -a on_param=(test)
