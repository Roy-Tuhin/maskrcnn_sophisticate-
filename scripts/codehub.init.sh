#!/bin/bash

sudo apt update -y
sudo apt install -y git

## for backward compatibility with lscripts (earlier: linuxscripts), as code migration would take time
mkdir -p ${HOME}/softwares

sudo mkdir -p /codehub
sudo chown -R $(id -un):$(id -gn) /codehub
#
git clone --recurse-submodules https://github.com/mangalbhaskar/codehub.git /codehub
cd /codehub
git submodule update --init --recursive

cd /codehub/scripts
source setup.sh

## aimldl.init.sh => taken care by setup.sh; here only for reference in case
# sudo mkdir -p /aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg
# sudo chown -R $(id -un):$(id -gn) /aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg
