#!/bin/bash

##----------------------------------------------------------
### Rclone - rsync for cloud storage
## Tested on Kali Linux 2019, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://about.gitlab.com/install/#ubuntu
## https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh
## https://tecadmin.net/install-gitlab-ce-on-ubuntu/
## https://packagecloud.io/docs
## https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md
## https://gitlab.com/gitlab-org/gitlab/-/tags
## https://docs.gitlab.com/ee/install/installation.html
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh


curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh > gitlab-ce.install.sh
sudo bash gitlab-ce.install.sh

sudo apt-get install gitlab-ce


# cd $LINUX_SCRIPT_HOME
