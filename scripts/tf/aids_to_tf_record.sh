#!/bin/bash

##----------------------------------------------------------
## AIDS to TFRecord creation
##----------------------------------------------------------
#

##----------------------------------------------------------

timestamp=$(date -d now +'%d%m%y_%H%M%S')

## NOTE: Following evnironment variables are mandatory

## /aimldl-dat/tfrecords
echo "AI_TFR: ${AI_TFR}"
## /codehub/external/tensorflow/models/research
echo "AI_TF_OD_API_PATH: ${AI_TF_OD_API_PATH}"


prog_aids2tfr="/codehub/apps/annon/aids_to_tf_record.py"
python ${prog_aids2tfr} -h

## sample aids and output_basepath for tfrecords: /aimldl-dat/tfrecords/hmd-PXL-270220_175734/290220_131155
# python aids_to_tf_record.py --dataset PXL-270220_175734 --image_basepath /aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns --did hmd --shards 5 --subset 'train,val,test'

## aids to tfrecord
# python ${prog_aids2tfr} \
#   --dataset PXL-270220_175734 \
#   --image_basepath /aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns \
#   --did hmd \
#   --shards 5 \
#   --subset 'train,val,test'


## coco from aids to tfrecord
python ${prog_aids2tfr} --dataset PXL-130220_151926 \
  --image_basepath '/aimldl-dat/data-public/ms-coco-1/train2014,/aimldl-dat/data-public/ms-coco-1/val2014' \
  --did coco \
  --shards 100 \
  --subset 'train,val'
