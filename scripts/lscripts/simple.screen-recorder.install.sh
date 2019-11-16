#!/bin/bash

#https://askubuntu.com/questions/4428/how-can-i-record-my-screen
sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
sudo apt update
sudo apt install -y simplescreenrecorder
# if you want to record 32-bit OpenGL applications on a 64-bit system:
#sudo apt-get install simplescreenrecorder-lib:i386
