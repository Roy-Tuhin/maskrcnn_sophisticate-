#!/bin/bash

cd /codehub/external/tensorflow/models/research

# ##----------------------------------------------------------
# ## Pascal VOC to tf record
# ##----------------------------------------------------------
# ## train
# python object_detection/dataset_tools/create_pascal_tf_record.py \
#     --label_map_path=object_detection/data/pascal_label_map.pbtxt \
#     --data_dir=/aimldl-dat/data-public/VOC/trainval --year=VOC2012 --set=train \
#     --output_path=/aimldl-dat/data-public/VOC/trainval/pascal_train.record


# ## val
# python object_detection/dataset_tools/create_pascal_tf_record.py \
#     --label_map_path=object_detection/data/pascal_label_map.pbtxt \
#     --data_dir=/aimldl-dat/data-public/VOC/trainval --year=VOC2012 --set=val \
#     --output_path=/aimldl-dat/data-public/VOC/trainval/pascal_val.record


# ##----------------------------------------------------------
# ## oxford-iiit-pet to tf record
# ## http://www.robots.ox.ac.uk/~vgg/data/pets/
# ##----------------------------------------------------------

# ## oxford-iiit-pet dataset
# python object_detection/dataset_tools/create_pet_tf_record.py \
#     --label_map_path=object_detection/data/pet_label_map.pbtxt \
#     --data_dir=/aimldl-dat/data-public/oxford-iiit-pet \
#     --output_dir=/aimldl-dat/data-public/oxford-iiit-pet


python object_detection/dataset_tools/create_coco_tf_record.py --logtostderr \
  --train_image_dir="/aimldl-dat/data-public/ms-coco-1/train2014" \
  --val_image_dir="/aimldl-dat/data-public/ms-coco-1/val2014" \
  --test_image_dir="/aimldl-dat/data-public/ms-coco-1/test2014" \
  --train_annotations_file="/aimldl-dat/data-public/ms-coco-1/annotations/instances_train2014.json" \
  --val_annotations_file="/aimldl-dat/data-public/ms-coco-1/annotations/instances_val2014.json" \
  --testdev_annotations_file="/aimldl-dat/data-public/ms-coco-1/annotations/image_info_test2014.json" \
  --output_dir="/aimldl-dat/data-public/ms-coco-1/tfrecord"
