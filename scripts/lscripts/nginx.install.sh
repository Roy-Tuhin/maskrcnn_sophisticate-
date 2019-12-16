#!/bin/bash

##----------------------------------------------------------
### Install utilities and softwares
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------

#sudo apt update
sudo apt -y install nginx
sudo ufw app list
sudo ufw allow 'Nginx HTTP'
sudo ufw status
sudo systemctl status nginx.service

## This will fail if apache is running, as nginx by defaults binds to port 80
# sudo systemctl stop apache2.service
# sudo systemctl start nginx
