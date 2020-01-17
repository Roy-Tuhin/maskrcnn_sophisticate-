#!/bin/bash

model_basepath=/aimldl-dat/logs/lanenet/model
echo "model_basepath is "${model_basepath}
model_path=$(ls -t ${model_basepath} | head -n 1)
echo "model_path is "${model_path}
model=$(ls -t ${model_basepath}/${model_path} | head -1 | cut -d. -f1-2 ) 
echo "model is "${model}

echo ${model_basepath}/${model_path}/${model}