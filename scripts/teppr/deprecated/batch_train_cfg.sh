#!/bin/bash

ip=69
cmd=train
dbname=hmd
pyver=3
arch=mask_rcnn
log_base_path=$AI_LOGS/$arch
prog=$AI_APP/falcon/main.py
cfg_base_path=$AI_APP/falcon/cfg