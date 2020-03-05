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

## COCO
dataset=PXL-130220_151926
image_basepath='/aimldl-dat/data-public/ms-coco-1/train2014,/aimldl-dat/data-public/ms-coco-1/val2014'
shards=100

dataset=PXL-270220_175734
image_basepath=/aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns
shards=5

dataset=PXL-010320_022938
image_basepath=/aimldl-dat/data-public/balloon_dataset/balloon/all
shards=3

# aids to tfrecord
python ${prog_aids2tfr} --dataset ${dataset} \
  --image_basepath ${image_basepath} \
  --shards ${shards} \
  --did hmd \
  --subset 'train,val,test'


# ## coco from aids to tfrecord
# python ${prog_aids2tfr} --dataset ${dataset} \
#   --image_basepath ${image_basepath} \
#   --shards ${shards} \
#   --did coco \
#   --subset 'train,val'
