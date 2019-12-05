#!/bin/bash

prog=${AI_APP}/falcon/falcon.py
cmd=predict
iou=0.80
iou=0.50
timestamp=$(date -d now +'%d%m%y_%H%M%S')
base_log_dir=${AI_LOGS}/mask_rcnn
# base_log_dir=/aimldl-dat/test

## set the path for folder or image name for the prediction
path="/aimldl-dat/samples/mask_rcnn"
# path="/aimldl-dat/samples/mask_rcnn/100818_135420_16716_zed_l_032.jpg"
# path="/aimldl-dat/samples/Trafic_Signs/100818_135420_16716_zed_l_032.jpg"


## copy and comment the following, replace with required values

# aids_db_name="PXL-171019_185702"

aids_db_name="PXL-171019_185702"
# expid="predict-4407b34d-1f59-4283-97e7-8a746d04aecf" ## working
# expid="predict-4407b34d-1f59-4283-97e7-8a746d04aecf"
# expid="predict-912dbe9e-8bea-42b5-adf7-ac3594df8490"
expid="predict-1cb8ffb4-8842-49a2-ac62-e5cf2398a258"


prog_log="${base_log_dir}/${cmd}_$(echo $iou | replace '.' '')-${aids_db_name}-${timestamp}.log"

echo "Executing this command...${cmd}"
echo "Log file: ${prog_log}"

## with_viz
echo "python ${prog} ${cmd} --dataset ${aids_db_name} --path ${path} --iou ${iou} --exp ${expid} --save_viz 1>${prog_log} 2>&1 &"
python ${prog} ${cmd} --dataset ${aids_db_name} --path ${path} --iou ${iou} --exp ${expid} --save_viz 1>${prog_log} 2>&1 &

# ## no_viz
# echo "python ${prog} ${cmd} --dataset ${aids_db_name} --path ${path} --iou ${iou} --exp ${expid} 1>${prog_log} 2>&1 &"
# python ${prog} ${cmd} --dataset ${aids_db_name} --path ${path} --iou ${iou} --exp ${expid} 1>${prog_log} 2>&1 &


tail -f ${prog_log}
