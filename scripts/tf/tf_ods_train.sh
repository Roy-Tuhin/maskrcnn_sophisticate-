#!/bin/bash


## TRAINING
## https://towardsdatascience.com/custom-object-detection-using-tensorflow-from-scratch-e61da2e10087
## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
#
## /codehub/external/tensorflow/models/research/object_detection/samples/configs


## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md
## https://github.com/tensorflow/models/tree/master/research/object_detection/g3doc

## From the tensorflow/models/research/ directory
timestamp=$(date -d now +'%d%m%y_%H%M%S')
tfcfg_name=ssd_mobilenet_v2_coco
## path to pipeline config file
## /codehub/cfg/tf_ods_config/ssd_mobilenet_v2_coco.config
PIPELINE_CONFIG_PATH=/codehub/cfg/tf_ods_config/${tfcfg_name}.config
## path to model directory
## /aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco
MODEL_DIR=/aimldl-dat/logs/tf_ods/${tfcfg_name}
# NUM_TRAIN_STEPS=50000
NUM_TRAIN_STEPS=500
SAMPLE_1_OF_N_EVAL_EXAMPLES=1
mkdir -p ${MODEL_DIR}

export PYTHONPATH=/codehub/external/tensorflow/models/research:${PYTHONPATH}
export PYTHONPATH=/codehub/external/tensorflow/models/research/slim:${PYTHONPATH}

cd /codehub/external/tensorflow/models/research
## where ${PIPELINE_CONFIG_PATH} points to the pipeline config and ${MODEL_DIR} points to the directory in which training checkpoints and events will be written to. Note that this binary will interleave both training and evaluation.
python object_detection/model_main.py \
  --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
  --model_dir=${MODEL_DIR} \
  --num_train_steps=${NUM_TRAIN_STEPS} \
  --sample_1_of_n_eval_examples=${SAMPLE_1_OF_N_EVAL_EXAMPLES} \
  --alsologtostderr

# /codehub/scripts/data-public/tf_ods_train.sh
# source tf_ods_train.sh 1>${AI_LOGS}/tf_ods/tf_ods_train-$(date -d now +'%d%m%y_%H%M%S').log 2>&1


## Logs & Errors

## https://github.com/tensorflow/models/issues/6028#issuecomment-453775336
