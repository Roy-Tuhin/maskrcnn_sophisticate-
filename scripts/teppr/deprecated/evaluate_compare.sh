#!/bin/bash

## Array Ref:
## https://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html

basepath='/home/prime/Documents/ai-ml-dl-data/logs/mask_rcnn'
iou050=('evaluate_hmd_110419_175557'  'evaluate_hmd_110419_180008'  'evaluate_hmd_110419_180418'  'evaluate_hmd_110419_180831'  'evaluate_hmd_110419_181617')
iou050=('evaluate_hmd_110419_175557'  'evaluate_hmd_120419_104201')
iou050=('evaluate_hmd_110419_175557' 'evaluate_hmd_110419_182205' 'evaluate_hmd_110419_190343' 'evaluate_hmd_110419_192718' 'evaluate_hmd_110419_195831' 'evaluate_hmd_120419_104201')

image_name='071218_095221_16717_zed_l_074.jpg.png'
vizdir='viz'

echo -e ${iou050[*]}
filepaths=''
for d in ${iou050[@]}; do
  filepath=$basepath'/'$d'/'$vizdir'/'$image_name
  filepaths=$filepaths' '$filepath
  echo -e $filepath
done

echo -e $filepaths
feh $filepaths
