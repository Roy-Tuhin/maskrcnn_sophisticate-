#!/bin/bash


watch -n 1 nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu

# nvidia-smi --help-query-gpu
# nvidia-smi -l 1
# watch -n 1 nvidia-smi

#function better-nvidia-smi () {
#    nvidia-smi
#    join -1 1 -2 3 \
#        <(nvidia-smi --query-compute-apps=pid,used_memory \
#                     --format=csv \
#          | sed "s/ //g" | sed "s/,/ /g" \
#          | awk 'NR<=1 {print toupper($0)} NR>1 {print $0}' \
#          | sed "/\[NotSupported\]/d" \
#          | awk 'NR<=1{print $0;next}{print $0| "sort -k1"}') \
#        <(ps -a -o user,pgrp,pid,pcpu,pmem,time,command \
#          | awk 'NR<=1{print $0;next}{print $0| "sort -k3"}') \
#        | column -t
#}

#better-nvidia-smi


## TBD: log gpustats
#nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l >> hmd-06032019.txt
#nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -lms >> hmd-06032019.txt



## TBD
##----------------------  
# nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l 1 -f $1


## https://towardsdatascience.com/burning-gpu-while-training-dl-model-these-commands-can-cool-it-down-9c658b31c171
## “GPUFanControlState=1” means you can change the fan speed manually, “[fan:0]” means which gpu fan you want to set, “GPUTargetFanSpeed=100” means setting the speed to 100%, but that will be so noisy, you can choose 80%.
# nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=80"

## https://www.andrey-melentyev.com/monitoring-gpus.html
# https://github.com/Syllo/nvtop#nvtop-build
# https://github.com/wookayin/gpustat

# https://timdettmers.com/2018/12/16/deep-learning-hardware-guide/

# https://developer.android.com/ndk/guides/neuralnetworks
# https://www.xenonstack.com/blog/log-analytics-deep-machine-learning/
# https://dzone.com/articles/how-to-train-tensorflow-models-using-gpus
# https://tutorials.ubuntu.com/tutorial/viewing-and-monitoring-log-files#0
# https://linoxide.com/linux-command/linux-pidstat-monitor-statistics-procesess/
# https://www.ubuntupit.com/most-comprehensive-list-of-linux-monitoring-tools-for-sysadmin/ - **best reference**
# https://www.nagios.com/solutions/linux-monitoring/
# https://github.com/nicolargo/glances
  # https://glances.readthedocs.io/
  # pip install glances
  # pip install 'glances[action,browser,cloud,cpuinfo,docker,export,folders,gpu,graph,ip,raid,snmp,web,wifi]'

# https://www.linuxtechi.com/monitor-linux-systems-performance-iostat-command/
# https://www.linuxtechi.com/generate-cpu-memory-io-report-sar-command/ - **best report generation by hands**

# cat /etc/sysstat/sysstat
# sar 2 5 -o /tmp/data > /dev/null 2>&1

## https://stackoverflow.com/questions/10508843/what-is-dev-null-21 

# https://en.wikipedia.org/wiki/Device_file#Pseudo-devices.

# >> /dev/null redirects standard output (stdout) to /dev/null, which discards it.

# 2>&1 redirects standard error (2) to standard output (1), which then discards it as well since standard output has already been redirected.

# & indicates a file descriptor. There are usually 3 file descriptors - standard input, output, and error.


# Let's break >> /dev/null 2>&1 statement into parts:

# Part 1: >> output redirection

# This is used to redirect the program output and append the output at the end of the file
# https://unix.stackexchange.com/questions/89386/what-is-symbol-and-in-unix-linux

# Part 2: /dev/null special file

# This is a Pseudo-devices special file.

# Command ls -l /dev/null will give you details of this file:

# crw-rw-rw-. 1 root root 1, 3 Mar 20 18:37 /dev/null
# Did you observe crw? Which means it is a pseudo-device file which is of character-special-file type that provides serial access.
# /dev/null accepts and discards all input; produces no output (always returns an end-of-file indication on a read)

# Part 3: 2>&1 file descriptor

# Whenever you execute a program, operating system always opens three files STDIN, STDOUT, and STDERR as we know whenever a file is opened, operating system (from kernel) returns a non-negative integer called as File Descriptor. The file descriptor for these files are 0, 1, 2 respectively.

# So 2>&1 simply says redirect STDERR to STDOUT

## https://linoxide.com/tools/vmstat-graphical-mode/
## https://github.com/joewalnes/websocketd


# https://glances.readthedocs.io/en/stable/cmds.html#interactive-commands


# https://www.vioan.eu/blog/2016/10/10/deploy-your-flask-python-app-on-ubuntu-with-apache-gunicorn-and-systemd/
# https://www.linode.com/docs/applications/big-data/how-to-move-machine-learning-model-to-production/
# https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
# https://blog.keras.io/building-a-simple-keras-deep-learning-rest-api.how-to-move-machine-learning-model-to-production