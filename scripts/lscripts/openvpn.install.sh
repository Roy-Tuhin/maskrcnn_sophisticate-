#!/bin/bash

##----------------------------------------------------------
### OpenVPN
##----------------------------------------------------------
sudo -E apt-get -q -y install openvpn
sudo -E openvpn --config ~/Downloads/fw-udp-1194-gaze-config.ovpn
