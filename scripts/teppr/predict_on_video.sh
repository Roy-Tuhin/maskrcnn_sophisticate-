#!/bin/bash

cd /codehub/apps/falcon

## video predictions using mask_rcnn


# ### For predict experiment type; change dimension to HD in yml files
# IMAGE_MAX_DIM: 1280
# IMAGE_MIN_DIM: 720
# # IMAGE_MAX_DIM: 1920
# # IMAGE_MIN_DIM: 1080

# /codehub/apps/falcon/arch/Model.py
  ## customization; bbox or nobbox
  ## jsonres = viz.get_display_instances(oframe_im_rgb, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'], colors=cc, show_bbox=False, auto_show=False, filepath=video_viz_basepath, filename=oframe_name)

# /codehub/apps/viz.py
  ## label with score
  ## label without score
  # caption = "{}".format(label)


## coco
# python falcon.py predict --exp /codehub/cfg/arch/coco_things-mask_rcnn.yml --path /aimldl-dat/samples/video/MAH04240.mp4 --save_viz

## drivable area
python falcon.py predict --exp /codehub/cfg/arch/road_asphalt-1-mask_rcnn.yml --path /aimldl-dat/samples/video/MAH04240.mp4 --save_viz

## white-marking with traffic sign
python falcon.py predict --exp /codehub/cfg/arch/tsdr-1-mask_rcnn.yml --path /aimldl-dat/samples/video/MAH04240.mp4 --save_viz

## hmd-1
python falcon.py predict --exp /codehub/cfg/arch/hmd-1-mask_rcnn.yml --path /aimldl-dat/samples/video/MAH04240.mp4 --save_viz


## ods-8 not needed; only for testing ods-8 quality
# python falcon.py predict --exp /codehub/cfg/arch/ods-8-mask_rcnn.yml --path /aimldl-dat/samples/video/MAH04240.mp4 --save_viz

