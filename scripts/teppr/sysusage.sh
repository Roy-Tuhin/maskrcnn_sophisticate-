#!/bin/bash

nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l 1 -f $1


## https://towardsdatascience.com/burning-gpu-while-training-dl-model-these-commands-can-cool-it-down-9c658b31c171
## “GPUFanControlState=1” means you can change the fan speed manually, “[fan:0]” means which gpu fan you want to set, “GPUTargetFanSpeed=100” means setting the speed to 100%, but that will be so noisy, you can choose 80%.
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=80"

## https://www.andrey-melentyev.com/monitoring-gpus.html
# https://github.com/Syllo/nvtop#nvtop-build