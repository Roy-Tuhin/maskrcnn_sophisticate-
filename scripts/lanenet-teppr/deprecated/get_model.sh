#!/bin/bash

model_basepath=/aimldl-dat/logs/lanenet/model/
model_path=$(ls -td ${model_basepath}* | head -n 1) 
model=$(ls -t ${model_path} | head -1 | cut -d. -f1-2 ) 

echo ${model_path}/${model}