#!/bin/bash

echo "NOT Working properly: TBD"
URL=$1 # "deb https://qgis.org/debian"
FILE=$2 # "qgis3.list"
OS_CODE_NAME=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d'=' -f2);

if [ ! -z "$1" ] && [ ! -z "$2" ]; then
  ## Test
  # echo $URL
  # echo $FILE
  # echo $OS_CODE_NAME
  # ls /etc/apt/sources.list.d/$FILE
  sudo sh -c 'echo "$URL $OS_CODE_NAME main" > /etc/apt/sources.list.d/"$FILE"'
else
  echo "Usage: example"
  echo $0 "deb https://qgis.org/debian" qgis3.list
fi