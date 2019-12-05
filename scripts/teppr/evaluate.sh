#!/bin/bash

pyver=3
pyenv=$(lsvirtualenv -b | grep ^py_${pyver} | tr '\n' ',' | cut -d',' -f1)

echo "Using python environment: ${pyenv}"
workon ${pyenv}

prog=${AI_APP}/falcon/falcon.py
cmd=evaluate

eval_on=train
eval_on=val
# eval_on=test

# iou=0.90
# iou=0.70
# iou=0.80
# iou=0.65
iou=0.50

timestamp=$(date -d now +'%d%m%y_%H%M%S')
base_log_dir=${AI_LOGS}/mask_rcnn

## copy and comment the following, replace with required values

## --- Alpha server
# aids_db_name="PXL-171019_185702"
# expid="evaluate-e1966758-3ce7-469f-8d6c-eb358bd48de0"

# aids_db_name="PXL-171019_185702"
# expid="evaluate-d1fe91eb-e723-4d3a-b4e7-16c569cec8b9"

# aids_db_name="PXL-171019_185702"
# expid="evaluate-8bf38ed7-51cc-46ee-a776-0e6514df9633"

# aids_db_name="PXL-171019_185702"
# expid="evaluate-d6d9d97d-1e0f-4136-a920-02e91ddd7864"

aids_db_name="PXL-171019_185702"
expid="evaluate-3265d0fb-0ceb-4505-b3c7-0752a6839392"

aids_db_name="PXL-081119_193452"
expid="evaluate-41d2fe86-99eb-4ddd-97d4-eb8d60ee80a9"
## ---

##--- my laptop
# aids_db_name="PXL-051119_111755"
# expid="evaluate-ae104a4f-0b75-426e-983e-698fb0d5864a"

# aids_db_name="PXL-071119_235057"
# expid="evaluate-239bb29e-b25c-4891-bd5a-d9270d8b96ec"
## ---

prog_log="${base_log_dir}/${cmd}_$(echo $iou | replace '.' '')-${eval_on}-${aids_db_name}-${timestamp}.log"

echo "Executing this command...${cmd}"
echo "Log file: ${prog_log}"

## with_viz
echo "python ${prog} ${cmd} --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid} --save_viz 1>${prog_log} 2>&1 &"
python ${prog} ${cmd} --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid} --save_viz 1>${prog_log} 2>&1 &

# ## no_viz
# echo "python ${prog} ${cmd} --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid} 1>${prog_log} 2>&1 &"
# python ${prog} ${cmd} --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid} 1>${prog_log} 2>&1 &


echo ${prog_log}
# tail -f ${prog_log} | grep "STATS: match_count: "
tail -f ${prog_log} | grep "@IoU, SAVED_FILE_NAME: "
