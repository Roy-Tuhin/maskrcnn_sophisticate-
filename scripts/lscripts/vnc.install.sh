#!/bin/bash

##----------------------------------------------------------
### vnc4server
##----------------------------------------------------------
sudo apt install -y ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal
sudo apt install -y vnc4server

##----------------------------------------------------------
### configuration
##----------------------------------------------------------
#--- open <editor> ~/.vnc/xstartup
#this has to be done after setting up of vnc4server
#to start the vnc4server command is: vnc4server
#Add the following line.

gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
#gnome-terminal &

#Save and close it
#then kill the vnc4server server command: vnc4server -kill :<number>
#then start again using command: vnc4server
