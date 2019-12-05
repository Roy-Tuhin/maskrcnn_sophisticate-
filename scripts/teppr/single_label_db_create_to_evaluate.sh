#!/bin/bash

## To re-initialize the counter on the same terminal
## export __RUN_BATCH_EVALUATE_COUNT__=0

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

function single_label_dbs() {
  source "${SCRIPTS_DIR}/common.sh"

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  local execution_start_time=$(date)
  local pyver=3
  local arch=mask_rcnn

  local prog_falcon=${AI_APP}/falcon/falcon.py
  local prog_teppr=${AI_ANNON_HOME}/teppr.py
  local prog_db_to_aids=${AI_ANNON_HOME}/db_to_aids.py

  local base_log_dir_annon=${AI_LOGS}/annon
  local base_log_dir_arch=${AI_LOGS}/${arch}

  local uuid=$(uuidgen)
  local username=$(whoami)
  local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)


  local summary_file=evaluate-mask_rcnn.csv
  local summary_filepath=${base_log_dir_arch}/${summary_file}
  local iou=0.50
  declare -a on_param=(test val train)
  # declare -a on_param=(test)

  ## For vidteq-hmd-1-mask_rcnn.yml
  local archcfg="/aimldl-cfg/arch/061119_191300-AIE1-10-mask_rcnn.yml"

  ## all 26 labels in chronological orders
  local annon_labels_arr=(cctv_camera footpath_polygon loose_material traffic_sign traffic_sign_frame lane_marking road_polygon pole reflector roadside_spot_light signage street_light traffic_light barricade billboard garbage_can roadside_junction_box transformer crosswalk speed_breaker booth flyover_pillar pothole garbage_pile lane_arrow_marking traffic_pole)
  # local annon_labels_arr=(cctv_camera traffic_sign signage street_light traffic_light)
  # local annon_labels_arr=(cctv_camera traffic_sign signage traffic_light)
  # ## subset of labels for testing
  # local annon_labels_arr=(cctv_camera footpath_polygon)
  # local annon_labels_arr=(cctv_camera)

  mkdir -p ${base_log_dir_annon}

  workon ${pyenv}

  for label in "${annon_labels_arr[@]}"; do
    echo "Processing for: ${label}"
    local prog_log="${base_log_dir_annon}/db_to_aids-create-${label}.output-${timestamp}.log"
    python ${prog_db_to_aids} create --by AIE3 --did hmd --labels ${label} 1>${prog_log} 2>&1
    echo "Log file: ${prog_log}"

    local aids_db_name=$(grep "AIDS(AI Dataset):" ${prog_log} | rev | cut -d' ' -f1 | rev)
    echo "${aids_db_name},${label}"

    ## create experiment
    python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp evaluate 1>>${prog_log} 2>&1

    local expid=$(grep "CFG(Annotation Database) res:" ${prog_log} | rev | cut -d' ' -f1 | rev)
    echo "${aids_db_name},${label},${expid}"

    for eval_on in "${on_param[@]}"; do
      prog_log_evaluate="${base_log_dir_arch}/evaluate_$(echo ${iou} | replace '.' '')-${eval_on}-${aids_db_name}-${timestamp}.log"

      echo "Executing... python ${AI_APP}/falcon/falcon.py evaluate --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid} 1>${prog_log_evaluate} 2>&1"
      python ${prog_falcon} evaluate --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid} 1>${prog_log_evaluate} 2>&1
      if [ -f ${prog_log_evaluate} ]; then
        rpt_imagelist_filepath=$(grep "EVALUATE_REPORT:IMAGELIST" ${prog_log_evaluate} | cut -d':' -f3)
        rpt_metric_filepath=$(grep "EVALUATE_REPORT:METRIC" ${prog_log_evaluate} | cut -d':' -f3)
        rpt_summary_filepath=$(grep "EVALUATE_REPORT:SUMMARY" ${prog_log_evaluate} | cut -d':' -f3)
      fi
      export __RUN_BATCH_EVALUATE_COUNT__=$(($__RUN_BATCH_EVALUATE_COUNT__+1))
      echo "$__RUN_BATCH_EVALUATE_COUNT__,${uuid},${username},${eval_on},${iou},${expid},${prog_log_evaluate},${rpt_imagelist_filepath},${rpt_metric_filepath},${rpt_summary_filepath}" >> ${summary_filepath}

      echo "===x==x==x==="

      ## Kill exisiting python programs before starting new
      pids=$(pgrep -f ${prog_falcon})
      info "These ${prog_falcon} pids will be killed: ${pids}"
      pkill -f ${prog_falcon}
    done

  done


  # local prog_log="${base_log_dir_annon}/db_to_aids-create.output-${timestamp}.log"
  # python ${prog_db_to_aids} create --by AIE3 --did hmd --labels cctv_camera,traffic_sign,signage,traffic_light 1>${prog_log} 2>&1
  # echo "Log file: ${prog_log}"

  # local aids_db_name=$(grep "AIDS(AI Dataset):" ${prog_log} | rev | cut -d' ' -f1 | rev)
  # echo "${aids_db_name}"

  # aids_db_name=PXL-161019_175838
  # ## create experiment
  # python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp evaluate 1>>${prog_log} 2>&1

  # local expid=$(grep "CFG(Annotation Database) res:" ${prog_log} | rev | cut -d' ' -f1 | rev)
  # echo "${aids_db_name},${expid}"

}

single_label_dbs
