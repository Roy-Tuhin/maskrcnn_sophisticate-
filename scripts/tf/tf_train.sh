#!/bin/bash

##----------------------------------------------------------
## TF Object Detection API - training
##----------------------------------------------------------
#
## TRAINING
## https://towardsdatascience.com/custom-object-detection-using-tensorflow-from-scratch-e61da2e10087
## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
## https://github.com/tensorflow/models/issues/6100
#
## /codehub/external/tensorflow/models/research/object_detection/samples/configs
#
## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md
## https://github.com/tensorflow/models/tree/master/research/object_detection/g3doc
##----------------------------------------------------------

## From the tensorflow/models/research/ directory
timestamp=$(date -d now +'%d%m%y_%H%M%S')


## /codehub/cfg/tf_ods_config/ssd_mobilenet_v2_coco.config
## /codehub/cfg/tf_ods_config/ssd_mobilenet_v2_annon-280220_172500.config
## /codehub/cfg/tf_ods_config/ssd_mobilenet_v2_quantized_300x300_coco-290220_133017.config

# tfcfg_name=ssd_mobilenet_v2_coco
# tfcfg_name=ssd_mobilenet_v2_annon-280220_172500
# tfcfg_name=ssd_mobilenet_v2_quantized_300x300_coco-290220_133017
tfcfg_name=ssd_mobilenet_v2_annon-PXL-010320_022938

## path to pipeline config file
PIPELINE_CONFIG_PATH=/codehub/cfg/tf_ods_config/${tfcfg_name}.config
## path to model directory
## /aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco
MODEL_DIR=/aimldl-dat/logs/tf_ods/${tfcfg_name}
# NUM_TRAIN_STEPS=50000
NUM_TRAIN_STEPS=5000
# NUM_TRAIN_STEPS=50
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


##----------------------------------------------------------
## Errors & Logs
# ##----------------------------------------------------------

# ## https://github.com/tensorflow/models/issues/6028#issuecomment-453775336

# 2020-02-29 11:35:57.903698: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
# 2020-02-29 11:35:57.903732: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
# 2020-02-29 11:35:57.903742: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
# 2020-02-29 11:35:57.903750: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0

# I changed my tensorflow-gpu version from 1.14.0 to 1.13.1, this issue happened, so I just install it back with pip install tensorflow-gpu==1.14.0, and the issue disappeared.

# https://github.com/matterport/Mask_RCNN/issues/1264#issuecomment-568875440
# https://github.com/tensorflow/tensorflow/issues/26769
# https://github.com/tensorflow/tensorflow/issues/29052