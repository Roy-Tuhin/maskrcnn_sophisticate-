#!/bin/bash

##----------------------------------------------------------
## Rasdaman
## Tested on Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------
#
## https://prometheus.io/docs/prometheus/latest/getting_started/
## https://prometheus.io/download/
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

PROMETHEUS_VER=2.14.0
PROG=prometheus
DIR=${PROG}-${PROMETHEUS_VER}.linux-amd64
PROG_DIR=$BASEPATH/${DIR}
FILE=${DIR}.tar.gz

## https://github.com/prometheus/prometheus/releases/download/v2.14.0/prometheus-2.14.0.linux-amd64.tar.gz
URL=https://github.com/${PROG}/${PROG}/releases/download/v${PROMETHEUS_VER}/${FILE}


echo "$FILE"
echo "URL: $URL"
echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c $URL -P $HOME/Downloads
else
  echo "Not downloading as: $HOME/Downloads/$FILE already exists!"
fi

if [ ! -d ${PROG_DIR} ]; then
  # tar xvfz $HOME/Downloads/$FILE -C $BASEPATH #verbose
  tar xfz $HOME/Downloads/$FILE -C $BASEPATH #silent mode
  echo "Extracting File: $HOME/Downloads/$FILE here: $PROG_DIR"
  echo "Extracting...DONE!"
else
  echo "Extracted Dir already exists: $PROG_DIR"
fi


## Node Exporter
URL=https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
wget -c $URL -P $HOME/Downloads

## configure prometheus:
## https://prometheus.io/docs/prometheus/latest/configuration/configuration/

# touch ${PROG_DIR}/prometheus.yml

## Start Prometheus.
# By default, Prometheus stores its database in ./data (flag --storage.tsdb.path).
# source ${PROG_DIR}/prometheus --config.file=prometheus.yml