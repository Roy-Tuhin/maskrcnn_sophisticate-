#!/bin/bash


# -------------------------------------------------------
## Credits:
## Modded using original code by Vivek Gite <www.cyberciti.biz> under GPL v2.x+
## https://www.cyberciti.biz/faq/linux-find-out-raspberry-pi-gpu-and-arm-cpu-temperature-command/
#
## Ref:
## https://github.com/nezticle/RaspberryPi-BuildRoot/wiki/VideoCore-Tools
## https://stackoverflow.com/questions/5297638/bash-how-to-end-infinite-loop-with-any-key-pressed
#
# -------------------------------------------------------

echo "$(date) @ $(hostname)"
echo "-------------------------------------------"

## Display Raspberry Pi ARM CPU temperature
## CPU temp: Divide it by 1000 to get the ARM CPU temperature in more human readable format:

echo "CPU temp, GPU temp"
echo "$(/opt/vc/bin/vcgencmd measure_temp), $(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))'C"

## Infinite loop till any key is pressed
if [ -t 0 ]; then
  old_tty=$(stty --save)
  stty raw -echo min 0
fi
while
  IFS= read -r REPLY
  [ -z "$REPLY" ]
  echo "$(/opt/vc/bin/vcgencmd measure_temp), $(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))'C"
  sleep 0.1
do :; done
if [ -t 0 ]; then stty "$old_tty"; fi
