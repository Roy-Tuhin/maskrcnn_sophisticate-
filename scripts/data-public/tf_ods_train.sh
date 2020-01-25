#!/bin/bash


## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md

## From the tensorflow/models/research/ directory

timestamp=$(date -d now +'%d%m%y_%H%M%S')
tfcfg_name=ssd_mobilenet_v2_coco
## path to pipeline config file
PIPELINE_CONFIG_PATH=/codehub/cfg/tf_ods_config/${tfcfg_name}.config
## path to model directory
MODEL_DIR=/aimldl-dat/logs/tf_ods/${tfcfg_name}-${timestamp}

NUM_TRAIN_STEPS=50000
SAMPLE_1_OF_N_EVAL_EXAMPLES=1

mkdir -p ${MODEL_DIR}

cd /codehub/external/tensorflow/models/research

## where ${PIPELINE_CONFIG_PATH} points to the pipeline config and ${MODEL_DIR} points to the directory in which training checkpoints and events will be written to. Note that this binary will interleave both training and evaluation.

python object_detection/model_main.py \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --num_train_steps=${NUM_TRAIN_STEPS} \
    --sample_1_of_n_eval_examples=${SAMPLE_1_OF_N_EVAL_EXAMPLES} \
    --alsologtostderr