#!/bin/bash

timestamp_start=$(date -d now +'%d%m%y_%H%M%S')
execution_start_time=$(date)

arch=mask_rcnn
# archcfg="/aimldl-cfg/arch/281119_123250-AIE1-21-mask_rcnn.yml"
archcfg="/aimldl-cfg/arch/291119_174050-TST1-21-mask_rcnn.yml"

prog_falcon=${AI_APP}/falcon/falcon.py
prog_teppr=${AI_ANNON_HOME}/teppr.py

base_log_dir=${AI_LOGS}/${arch}

uuid=$(uuidgen)
username=$(whoami)

pyver=3
pyenv=$(lsvirtualenv -b | grep ^py_${pyver} | tr '\n' ',' | cut -d',' -f1)

cmd1=train
cmd2=evaluate

summary_file=${cmd1}-${cmd2}-${arch}.csv
summary_filepath=${base_log_dir}/${summary_file}


##----------------------------------------------------------
### AI Workload for single run or batch
##----------------------------------------------------------

## this iou is only used to visualize the data if save_viz flag is enabled, but its mandatory to pass this option for now
iou=0.50

declare -a on_param=(val)

declare -a aids_dbs=("PXL-281119_140106" "PXL-281119_144018" "PXL-281119_144432" "PXL-281119_154739")
declare -a experiment_ids=("train-17b1d393-22ab-4d3f-bf5a-d8c85cade6c1" "train-9e5fcde9-907e-4beb-b9c8-bf3bb3e6d14b" "train-a2225da9-99d6-4e26-b428-c48def98a0cd" "train-9c10ab9e-79a5-4e99-bfad-0ae2fc5fe215")

## use in cased when training is successful but evaluate failed

declare -a train_logs=("train.output-291119_181403.log" "train.output-291119_181919.log" "train.output-291119_182429.log" "train.output-291119_182945.log")