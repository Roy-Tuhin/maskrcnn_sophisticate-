
# declare -a no_of_dbs=($(seq 1 1 4)) ## 4 items

declare -a annon_dbnames=(
  "annon_v8"
  "annon_v5"
)

declare -a aids_dbs=(
  "PXL-281119_154739"
  "PXL-151119_175327"
)


# archcfg="/aimldl-cfg/arch/281119_123250-AIE1-21-mask_rcnn.yml"
declare -a archcfg=(
  "/aimldl-cfg/arch/101219_152450-AIE1-22-mask_rcnn.yml"
  "/aimldl-cfg/arch/101219_152632-AIE1-23-mask_rcnn.yml"
)

declare -a experiment_ids=(
  "train-900ce199-8c0a-4ae6-b47f-12bd4a71f6ae"
  "train-8daf9260-1724-4a8a-9917-742f9885b9b9"
)


## use in cased when training is successful but evaluate failed

# declare -a train_logs=("train.output-291119_181403.log" "train.output-291119_181919.log" "train.output-291119_182429.log" "train.output-291119_182945.log")