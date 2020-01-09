
# declare -a no_of_dbs=($(seq 1 1 4)) ## 4 items

declare -a annon_dbnames=(
  "annon_v9"
)

declare -a aids_dbs=(
  "PXL-291119_180404"
)


declare -a archcfg=(
  "${AI_CFG}/arch/090120_151820-TST1-38-mask_rcnn.yml"
)

# declare -a experiment_ids=(
#   "train-ce83dfd4-ef53-4cdd-b4e4-fe9269ac3869"
# )


## use in cased when training is successful but evaluate failed

# declare -a train_logs=("train.output-291119_181403.log" "train.output-291119_181919.log" "train.output-291119_182429.log" "train.output-291119_182945.log")