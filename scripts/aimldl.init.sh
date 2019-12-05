#!/bin/bash

sudo apt update
sudo apt install -y git
#
sudo mkdir -p /aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg
sudo chown -R $(id -un):$(id -gn) /aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg

mkdir -p $HOME/softwares
#
git clone --recurse-submodules https://github.com/mangalbhaskar/aimldl.git /aimldl-cod
cd /aimldl-cod
git submodule update --init --recursive
