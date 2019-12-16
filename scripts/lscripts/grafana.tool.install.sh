#!/bin/bash

##----------------------------------------------------------
## grafana
## Tested on Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------
#
## https://grafana.com/grafana/download
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

GRAFANA_VER=6.4.4
PROG=grafana
DIR=${PROG}-${GRAFANA_VER}_amd64
PROG_DIR=$BASEPATH/${DIR}
FILE=${PROG}_${GRAFANA_VER}_amd64.deb

## wget https://dl.grafana.com/oss/release/grafana_6.4.4_amd64.deb 
URL=https://dl.grafana.com/oss/release/${FILE}

echo "$FILE"
echo "URL: $URL"
echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "PROG_DIR: $PROG_DIR"

wget -c $URL -P $HOME/Downloads
# if [ ! -f $HOME/Downloads/$FILE ]; then
#   wget -c $URL -P $HOME/Downloads
# else
#   echo "Not downloading as: $HOME/Downloads/$FILE already exists!"
# fi

if [ -f $HOME/Downloads/${FILE} ]; then
  sudo dpkg -i $HOME/Downloads/${FILE}
fi

# Selecting previously unselected package grafana.
# (Reading database ... 504340 files and directories currently installed.)
# Preparing to unpack .../grafana_6.4.4_amd64.deb ...
# Unpacking grafana (6.4.4) ...
# Setting up grafana (6.4.4) ...
# Adding system user `grafana' (UID 132) ...
# Adding new user `grafana' (UID 132) with group `grafana' ...
# Not creating home directory `/usr/share/grafana'.
# ### NOT starting on installation, please execute the following statements to configure grafana to start automatically using systemd
#  sudo /bin/systemctl daemon-reload
#  sudo /bin/systemctl enable grafana-server
# ### You can start grafana-server by executing
#  sudo /bin/systemctl start grafana-server
# Processing triggers for systemd (240-4) ...
