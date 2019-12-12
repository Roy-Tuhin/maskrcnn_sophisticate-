#!/bin/bash

timestamp_start=$(date -d now +'%d%m%y_%H%M%S')
execution_start_time=$(date)

arch=mask_rcnn
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
