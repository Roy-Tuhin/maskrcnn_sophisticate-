#!/bin/bash

##----------------------------------------------------------
## After successful Nvidia Driver installation
## check version of Driver installed
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

#source $LSCRIPTS/linuxscripts.config.sh

echo ""
echo "check version of Driver installed"
nvidia-settings -q gpus

# show all attributes
#echo ""
#echo "show all attributes"
#nvidia-settings -q all

nvidia-smi
nvidia-smi -q | grep "Driver Version"
#nvidia-smi -h
#nvidia-smi --help-query-gpu
#nvidia-smi --query-gpu=count,gpu_name,memory.total,driver_version,clocks.max.memory,compute_mode --format=csv,noheader
nvidia-smi --query-gpu=count,gpu_name,memory.total,driver_version,clocks.max.memory,compute_mode --format=csv

lsmod | grep -i nouveau # this should not return anything

lsmod | grep -i nvidia # this should not return anything
### sample output
## nvidia_drm             49152  0
## nvidia_modeset       1114112  1 nvidia_drm
## nvidia              18808832  1 nvidia_modeset
## drm_kms_helper        204800  2 nvidia_drm,i915
## ipmi_msghandler        65536  2 ipmi_devintf,nvidia
## drm                   487424  6 drm_kms_helper,nvidia_drm,i915


prime-select query # should return: nvidia

