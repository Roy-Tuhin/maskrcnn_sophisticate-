
# declare -a no_of_dbs=($(seq 1 1 4)) ## 4 items

declare -a annon_dbnames=(
  "annon_v11"
)

declare -a aids_dbs=(
  "PXL-301219_174758"
)


declare -a archcfg=(
  "${AI_CFG}/arch/170120_175319-AIE1-44-mask_rcnn.yml"
)

# declare -a experiment_ids=(
#   "train-ce83dfd4-ef53-4cdd-b4e4-fe9269ac3869"
# )


## use in cased when training is successful but evaluate failed

# declare -a train_logs=("train.output-291119_181403.log" "train.output-291119_181919.log" "train.output-291119_182429.log" "train.output-291119_182945.log")