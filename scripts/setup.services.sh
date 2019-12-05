#!/bin/bash

##----------------------------------------------------------
### Setup the services to startup on-boot
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------

source setup.sh
sudo systemctl enable docker
sudo cp /aimldl-cfg/systemd/gunicorn.service /etc/systemd/system/
sudo systemctl enable gunicorn.service

## https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs
## sudo journalctl -u gunicorn.service

##----------------------------------------------------------
### if nginx as a load balancer is required, uncomment below
##----------------------------------------------------------

# sudo cp /aimldl-cfg/nginx/load_balancer.conf /etc/nginx/sites-available/
# sudo ln -s /etc/nginx/sites-available/load_balancer.conf /etc/nginx/sites-enabled
# sudo rm /etc/nginx/sites-enabled/default

# sudo systemctl enable nginx.service
# sudo systemctl start nginx.service

# sudo systemctl reload nginx.service
# sudo systemctl restart nginx.service

## Check for logs
##-------

## sudo journalctl -xe
## sudo tail -f /var/log/nginx/error.log /var/log/nginx/access.log


## Additional configuration, to be done manually
##-------

## Port conflict with apache: stop and disable apache as it binds to the same port 80
##---
# sudo systemctl stop apache2.service
# sudo systemctl disable apache2.service


## Settings for Nginx: Nginx 413 Request Entity Too Large
##---

## sudo  vi /etc/nginx/nginx.conf
## ## the command below in http section. You can replace the number as file size limit that you want.
## http {
##   client_max_body_size 8M;
## }
# ## test the syntax and if no error, restart the service
## sudo nginx -t
## sudo systemctl restart nginx.service

##----------------------------------------------------------
