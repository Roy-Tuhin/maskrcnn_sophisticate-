#!/bin/bash

dirpath='/aimldl-dat/logs/mask_rcnn/evaluate_080-hmd-test-041119_140302'
filepath="${dirpath}/classification_rpt-test-per_image.json"
ap_filepath="${dirpath}/ap.csv"

echo "dirpath: ${dirpath}"
echo "ap_filepath: ${ap_filepath}"

grep AP ${filepath} | rev | cut -d' ' -f1 | rev | cut -d',' -f1 > ${ap_filepath}
