#!/bin/bash

##----------------------------------------------------------
## Mount Help Guide
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
## Install Packages
##----------------------------------------------------------
#
#sudo apt install nfs-common
#sudo apt install smb4k
#sudo apt install cifs-utils
#
##----------------------------------------------------------
# References
##----------------------------------------------------------
#
## https://serverfault.com/questions/414074/mount-cifs-host-is-down
## if `vers=1.0` is not provided in `Ubuntu 18.04 LTS` it throws error `host is down`
#
## https://unix.stackexchange.com/questions/68079/mount-cifs-network-drive-write-permissions-and-chown
## sudo mount -t cifs //server-address/folder /mount/path/on/ubuntu -o username=${USER},password=${PASSWORD},uid=$(id -u),gid=$(id -g)
#
##----------------------------------------------------------
## TBD List:
##----------------------------------------------------------
#
## TBD: mount error handling
## mount error(16): Device or resource busy
## https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script
#
##----------------------------------------------------------

IP=$1
USERNAME=$2
if [ -z "$USERNAME" ]; then
  echo "Usage:"
  echo "$0 <samba_server_username>"
  exit -1
fi
## SHARED_DIR_NAME is not the name of the folder on the file system, rather the shared folder name
SHARED_DIR_NAME=$3
MNT_DIR=$4
DOMAIN=$5

## Assuming mount point exists already or create first
## sudo mkdir $MNT_DIR

sudo mount -t cifs //$IP/$SHARED_DIR_NAME $MNT_DIR -o username=$USERNAME,domain=$DOMAIN,uid=$(id -u),gid=$(id -g),vers=1.0

echo "Successfully mounted at: $MNT_DIR"
echo "changing to mounted dir..."
echo ""
echo "For unmounting execute: "
echo "sudo umount $MNT_DIR"
echo "Have Fun!"

cd $MNT_DIR
# sudo umount $MNT_DIR
