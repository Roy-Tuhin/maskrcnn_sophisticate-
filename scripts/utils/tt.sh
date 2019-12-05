#!/bin/bash

## https://stackoverflow.com/questions/24527431/print-only-matching-word-not-entire-line-through-grep
## https://unix.stackexchange.com/questions/147582/matching-string-with-a-fixed-number-of-characters-using-grep

# grep -oE '"total_execution_time":[\s 0-9\.]+' *.json
# echo '(3+4)/2' |bc -l

# # https://askubuntu.com/questions/705987/how-can-i-add-integers-in-an-array
# array=( 2, 4, 6, 8, 10, 12, 14, 16, 18, 20); echo "${array[@]/,/+}" | bc
##110
# "${array[@]/#/^}"


dirpath='/aimldl-dat/logs/mask_rcnn'
cd ${dirpath}
find . -iname "*.json" -type f -exec grep -HoE --color=auto '"total_execution_time":[\s 0-9\.]+' {} \;
tt=($(find . -iname "*.json" -type f -exec grep -HoE --color=auto '"total_execution_time":[\s 0-9\.]+' {} \; | rev | cut -d' ' -f1 | rev))

TT_hr=0
for t in "${tt[@]}"; do
  t_hr=$(echo ${t}/3600 | bc -l)
  echo ${t_hr}
  TT_hr=$(echo ${TT_hr} + ${t_hr} | bc -l)
done

echo "TT_hr: ${TT_hr}"
