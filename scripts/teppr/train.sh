#!/bin/bash

prog=${AI_APP}/falcon/falcon.py
cmd=train
timestamp=$(date -d now +'%d%m%y_%H%M%S')
base_log_dir=${AI_LOGS}/mask_rcnn
prog_log="${base_log_dir}/${cmd}.output-${timestamp}.log"

## copy and comment the following, replace with required values
# aids_db_name="PXL-091019_181910_101019_100955"
# expid="train-932699be-86e6-4326-adf9-e23bddc9e7e5"

# aids_db_name="PXL-161019_175838"
# expid="train-5f9f605c-df7f-4fb4-839f-f3641f37d32d"

# aids_db_name="PXL-171019_185702"
# expid="train-5217eb25-9964-41a2-a5a4-1737dbcbaf93"

# aids_db_name="PXL-171019_185702"
# expid="train-83e0e5b8-3aab-4dd7-a94b-92bc4fafa19f"

# aids_db_name="PXL-171019_185702"
# expid="train-fa045e7b-519b-4872-8ffa-d1a7532f2fe3"

# aids_db_name="PXL-171019_185702"
# expid="train-2d164ba1-8a1f-4cd1-8576-e6034f7115b4"

# aids_db_name="PXL-171019_185702"
# expid="train-8529dbd8-394e-48db-ac34-e7cdc8033795"

# aids_db_name="PXL-151119_175327"
# expid="train-a0d7264d-b70f-4564-9c19-06fb6536ef42"

# aids_db_name="PXL-151119_175327"
# expid="train-660d3f59-3b97-4920-8397-696bccfd1197"

aids_db_name="PXL-151119_175327"
expid="train-9dd0a31d-2c0f-4a49-ad87-d04e190b92bc"

echo "Executing this command...${cmd}"
echo "Log file: ${prog_log}"
echo "python ${prog} ${cmd} --dataset ${aids_db_name} --exp ${expid} 1>${prog_log} 2>&1 &"

# python ${prog} ${cmd} --dataset ${aids_db_name} --exp ${expid}
# python ${prog} ${cmd} --dataset ${aids_db_name} --exp ${expid} --modelinfo

# python ${prog} ${cmd} --dataset ${aids_db_name} --exp ${expid}
python ${prog} ${cmd} --dataset ${aids_db_name} --exp ${expid} 1>${prog_log} 2>&1 &
tail -f ${prog_log}
