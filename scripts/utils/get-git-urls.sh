#!/bin/bash

# ls -d $PWD/*
basepath_dir=/aimldl-cod/external
DIR_ARRAY=($(ls -d ${basepath_dir}/*))

filepath="/codehub/tmp/aimldlcod.external.jarvis.sh"

echo "DIR_ARRAY: ${DIR_ARRAY[@]}"

## //cd 
echo "git clone https:"$(git remote -v | grep -i fetch | cut -d':' -f2 | cut -d' ' -f1) >> 
