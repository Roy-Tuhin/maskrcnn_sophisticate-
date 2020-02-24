#!/bin/bash


## TRAINING

## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md
## From the tensorflow/models/research/ directory
timestamp=$(date -d now +'%d%m%y_%H%M%S')
tfcfg_name=ssd_mobilenet_v2_coco
## path to pipeline config file
## /codehub/cfg/tf_ods_config/ssd_mobilenet_v2_coco.config
PIPELINE_CONFIG_PATH=/codehub/cfg/tf_ods_config/${tfcfg_name}.config
## path to model directory
## /aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco
MODEL_DIR=/aimldl-dat/logs/tf_ods/${tfcfg_name}
NUM_TRAIN_STEPS=50000
SAMPLE_1_OF_N_EVAL_EXAMPLES=1
# mkdir -p ${MODEL_DIR}
# cd /codehub/external/tensorflow/models/research
# ## where ${PIPELINE_CONFIG_PATH} points to the pipeline config and ${MODEL_DIR} points to the directory in which training checkpoints and events will be written to. Note that this binary will interleave both training and evaluation.
# python object_detection/model_main.py \
#   --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
#   --model_dir=${MODEL_DIR} \
#   --num_train_steps=${NUM_TRAIN_STEPS} \
#   --sample_1_of_n_eval_examples=${SAMPLE_1_OF_N_EVAL_EXAMPLES} \
#   --alsologtostderr

## /codehub/scripts/data-public/tf_ods_train.sh
## source tf_ods_train.sh 1>${AI_LOGS}/tf_ods/tf_ods_train-$(date -d now +'%d%m%y_%H%M%S').log 2>&1

export PYTHONPATH=/codehub/external/tensorflow/models/research:${PYTHONPATH}
export PYTHONPATH=/codehub/external/tensorflow/models/research/slim:${PYTHONPATH}
cd /codehub/external/tensorflow/models/research
# model.ckpt-3126
CHECKPOINT_PATH=/aimldl-dat/logs/tf_ods/model.ckpt-3126
OUTPUT_DIR=/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco/TFLite_model
mkdir -p ${OUTPUT_DIR}

# python object_detection/export_inference_graph.py \
#   --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
#   --trained_checkpoint_prefix=${CHECKPOINT_PATH} \
#   --output_directory=${OUTPUT_DIR} \
#   --add_postprocessing_op=true

NETWORK_NAME="ssd_mobilenet_v2_coco"
OUTPUT_FILE=/aimldl-dat/logs/tf_ods/${timestamp}_inf_graph.pb
python object_detection/export_inference_graph.py \
  --alsologtostderr \
  --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
  --trained_checkpoint_prefix=${CHECKPOINT_PATH} \
  --batch_size=1 \
  --output_directory=${OUTPUT_DIR} \
  --model_name=${NETWORK_NAME} \
  --output_file=${OUTPUT_FILE} \
  --quantize

# ## https://github.com/parvizp/models/blob/b097785bbc5fc96ecf59605cb4a6d04e8b65e017/research/slim/scripts/quantize_mobilenet_v2_on_imagenet.sh
# ## Export an inference graph.
# python export_inference_graph.py \
#   --alsologtostderr \
#   --batch_size=1 \
#   --dataset_name=${DATASET_NAME} \
#   --model_name=${NETWORK_NAME} \
#   --output_file=${TRAIN_DIR}/${NETWORK_NAME}_inf_graph.pb \
#   --quantize

## https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi
## https://github.com/tensorflow/models/blob/master/research/object_detection/samples/configs/ssd_mobilenet_v2_quantized_300x300_coco.config

## set CONFIG_FILE=C:\\tensorflow1\models\research\object_detection\training\ssd_mobilenet_v2_quantized_300x300_coco.config
## set CHECKPOINT_PATH=C:\\tensorflow1\models\research\object_detection\training\model.ckpt-XXXX
## set OUTPUT_DIR=C:\\tensorflow1\models\research\object_detection\TFLite_model

# export PYTHONPATH=/codehub/external/tensorflow/models/research:${PYTHONPATH}
# export PYTHONPATH=/codehub/external/tensorflow/models/research/slim:${PYTHONPATH}
# cd /codehub/external/tensorflow/models/research
# # model.ckpt-3126
# CHECKPOINT_PATH=/aimldl-dat/logs/tf_ods/model.ckpt-3126
# OUTPUT_DIR=/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco/TFLite_model
# mkdir -p ${OUTPUT_DIR}

# python object_detection/export_tflite_ssd_graph.py \
#   --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
#   --trained_checkpoint_prefix=${CHECKPOINT_PATH} \
#   --output_directory=${OUTPUT_DIR} \
#   --add_postprocessing_op=true



# MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint

# https://github.com/tensorflow/models/issues/4156

