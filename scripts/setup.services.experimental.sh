#!/bin/bash

##----------------------------------------------------------
### Setup the services to startup on-boot
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------

function aimldl_setup_services() {
  ls -ltr ${AI_WSGIPythonPath}

  if [ $? -ne 0 ];then
      echo "Invalid AI_WSGIPythonPath: ${AI_WSGIPythonPath}"
      echo "Set the proper paths in aimldl.config.sh and re-run the aimldl.setup.sh script"
      return
  fi

  ## Used ONLY for API as a service
  declare -A AI_API=(
    [vidteq-rld-1]='vidteq-rld-1;4100;false'
    [vidteq-rbd-1]='vidteq-rbd-1;4110;false'
    [vidteq-ods-7]='vidteq-ods-7;4040;false'
  )

  local AI_WEB_APP_WORKING_DIRECTORY=${AI_WEB_APP}/od/wsgi-bin

  if [ -z $1 ]; then
    echo "please provide the API that needs to be deployed!"
    return
  fi
  
  echo "AI_API: ${AI_API[@]}"
  echo " "

  local ai_api_key=$1
  local api_item=${AI_API[${ai_api_key}]}
  declare -a api_item_vals=(${api_item//;/ })
  local API_MODEL_KEY=${api_item_vals[0]}
  local PORT=${api_item_vals[1]}
  local QUEUE=${api_item_vals[2]}

  local service_filepath=/etc/systemd/system/gunicorn.service
  local service_filepath=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/config/gunicorn.service

  if [ -z ${API_MODEL_KEY} ];then
    echo "Invalid API key, open and configure this file to set the proper keys!"
    return
  fi

sudo tee  ${service_filepath}<<EOF
[Unit]
Description=Gunicorn Daemon
After=network.target docker.service

[Service]
User=$(id -un)
Group=$(id -gn)
WorkingDirectory="${AI_WEB_APP_WORKING_DIRECTORY}"
Environment="PATH=${AI_WSGIPythonPath}"
ExecStart=${AI_WSGIPythonPath}/gunicorn web_server:"main(API_MODEL_KEY='${API_MODEL_KEY}', QUEUE='${QUEUE}')" -b "0.0.0.0:${PORT}"

[Install]
WantedBy=multi-user.target
EOF

}

aimldl_setup_services $1


# sudo systemctl enable docker
# # sudo cp /codehub/config/systemd/gunicorn.service /etc/systemd/system/gunicorn.service
# sudo systemctl enable gunicorn.service

# ## https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs
# ## sudo journalctl -u gunicorn.service

# ##----------------------------------------------------------
# ### if nginx as a load balancer is required, uncomment below
# ##----------------------------------------------------------

# # sudo cp /aimldl-cfg/nginx/load_balancer.conf /etc/nginx/sites-available/
# # sudo ln -s /etc/nginx/sites-available/load_balancer.conf /etc/nginx/sites-enabled
# # sudo rm /etc/nginx/sites-enabled/default

# # sudo systemctl enable nginx.service
# # sudo systemctl start nginx.service

# # sudo systemctl reload nginx.service
# # sudo systemctl restart nginx.service

# ## Check for logs
# ##-------

# ## sudo journalctl -xe
# ## sudo tail -f /var/log/nginx/error.log /var/log/nginx/access.log


# ## Additional configuration, to be done manually
# ##-------

# ## Port conflict with apache: stop and disable apache as it binds to the same port 80
# ##---
# # sudo systemctl stop apache2.service
# # sudo systemctl disable apache2.service


# ## Settings for Nginx: Nginx 413 Request Entity Too Large
# ##---

# ## sudo  vi /etc/nginx/nginx.conf
# ## ## the command below in http section. You can replace the number as file size limit that you want.
# ## http {
# ##   client_max_body_size 8M;
# ## }
# # ## test the syntax and if no error, restart the service
# ## sudo nginx -t
# ## sudo systemctl restart nginx.service


# ## How To's
# ## * List all services
# ## systemctl --type=service

# ## https://unix.stackexchange.com/questions/139513/how-to-clear-journalctl
# ## * Clear logs
# ## sudo journalctl -m --vacuum-time=1s 

# ## * Using environment file
# ## https://coreos.com/os/docs/latest/using-systemd-drop-in-units.html

# ##----------------------------------------------------------
