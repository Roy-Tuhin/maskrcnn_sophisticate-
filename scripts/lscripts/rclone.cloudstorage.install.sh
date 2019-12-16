#!/bin/bash

##----------------------------------------------------------
### Rclone - rsync for cloud storage
## Tested on Kali Linux 2019, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://rclone.org/install/
## https://github.com/rclone/rclone
#
## https://www.ostechnix.com/how-to-mount-google-drive-locally-as-virtual-file-system-in-linux/
## https://rclone.org/drive/#making-your-own-client-id
## https://community.alteryx.com/t5/Alteryx-Designer-Knowledge-Base/How-to-Create-Google-API-Credentials/ta-p/11834
## https://github.com/Cloudbox/Cloudbox/wiki/Google-Drive-API-Client-ID-and-Client-Secret

## https://developers.google.com/drive/activity/v1/guides/project
## https://developers.google.com/identity/protocols/googlescopes#drivev3
## https://cloud.google.com/storage/docs/gsutil/commands/config
## https://www.maketecheasier.com/rclone-sync-multiple-cloud-storage-providers-linux/
## https://www.labnol.org/internet/direct-links-for-google-drive/28356/ 
## https://github.com/rclone/rclone/issues/3631

## Rclone browser
## https://www.techrepublic.com/article/how-to-sync-from-linux-to-google-drive-with-rclone/
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh


curl https://rclone.org/install.sh > rclone.install.sh
sudo bash rclone.install.sh

## OR
# sudo apt install rclone


# man rclone
rclone config


# cd $LINUX_SCRIPT_HOME