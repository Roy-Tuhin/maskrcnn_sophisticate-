#!/bin/bash

file="evaluate_data-210519_130101.csv"

{
ed -s "$file" <<EOF
1
i
uuid,architecture,dataset,iou,on_param
.
wq
EOF
} > /dev/null