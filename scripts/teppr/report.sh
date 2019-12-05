#!/bin/bash

##----------------------------------------------------------
### 
## created on 
##----------------------------------------------------------
## Usage:
# E1024
# CFG:
# TRAINING_STARTED_AT:
# TOTAL_TRAINING_TIME:
# Epoch_Val:


# CFG:
# Training started at
# Total_training_time
##----------------------------------------------------------
## References:
# https://unix.stackexchange.com/questions/77277/how-to-append-multiple-lines-to-a-file
#
##----------------------------------------------------------

filepath='/aimldl-dat/logs/lanenet/train/lanenet-241019_192540.log'

# TRAINING_STARTED_AT=$(cat ${filepath} | grep 'Training started at')
# TOTAL_TRAINING_TIME=$(cat ${filepath} | grep 'Total_training_time')
# CFG=$(cat ${filepath} | grep 'CFG:')
# EPOCH_VAL=$(cat ${filepath} | grep 'Epoch_Val:')


timestamp=$(date -d now +'%d%m%y_%H%M%S')
base_log_dir=${AI_LOGS}
report_filepath=${base_log_dir}/report-${timestamp}.log
echo "report_filepath: ${report_filepath}"

cat <<EOT >> ${report_filepath}
LOG_FILEPATH: ${filepath}

$(cat ${filepath} | grep 'Training started at')
$(cat ${filepath} | grep 'Total_training_time')
$(cat ${filepath} | grep 'CFG:')
$(cat ${filepath} | grep 'Epoch_Val:')
EOT
