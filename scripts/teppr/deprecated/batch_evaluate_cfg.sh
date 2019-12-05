#!/bin/bash

cmd=evaluate
iou=0.80
eval_on=test

arch=mask_rcnn
timestamp=$(date -d now +'%d%m%y_%H%M%S')
prog=${AI_APP}/falcon/falcon.py
base_log_dir=${AI_LOGS}/${arch}

pyver=3
