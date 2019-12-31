#!/bin/bash

##----------------------------------------------------------
### sensors
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Ref:
## https://itsfoss.com/check-laptop-cpu-temperature-ubuntu/
#
##----------------------------------------------------------

#sudo -E apt update


## System Sensor monitors - temperature
sudo apt install lm-sensors hddtemp
sudo apt install psensor

# sudo sensors-detect
# watch -n 2 sensors
# watch -n 2 nvidia-smi

## System Resource Monitoring
sudo apt install htop atop dstat

# dstat -ta --top-cpu
# dstat -tcmndylp --top-cpu

# cat /proc/loadavg
# cat /proc/meminfo
