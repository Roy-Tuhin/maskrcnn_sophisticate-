#!/bin/bash

pyver=3
arch=lanenet
log_base_path=$AI_LOGS/$arch
pre_trained_model=$AI_LANENET_ROOT/model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt
prog=$AI_LANENET_ROOT/tools/train_lanenet.py
