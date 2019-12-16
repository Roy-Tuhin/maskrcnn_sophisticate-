#!/bin/bash

##----------------------------------------------------------
## Mounting Remote File System over ssh
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
## Install Packages
##----------------------------------------------------------
#
## sudo apt install sshfs
## sudo mkdir /mnt/droplet <--replace "droplet" whatever you prefer
## sudo sshfs -o allow_other,default_permissions <userName>@<IP>:</remote/path> </local/mount/path>
#
## sudo sshfs -o allow_other,default_permissions,IdentityFile=~/.ssh/id_rsa root@xxx.xxx.xxx.xxx:/ /mnt/droplet
## sudo umount /mnt/droplet
#
## sudo vi /etc/fstab
## sshfs#root@xxx.xxx.xxx.xxx:/ /mnt/droplet
#
##----------------------------------------------------------
# References
##----------------------------------------------------------
#
## https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh
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
#
## TODO:
## - install sshfs if it is not installed
#
##----------------------------------------------------------


if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

IP=$1
USERNAME=$2
if [ -z "$USERNAME" ]; then
  info "Usage:"
  info "$0 <remote_system_username>"
  return
fi
## SHARED_DIR_NAME is not the name of the folder on the file system, rather the shared folder name
SHARED_DIR_NAME=$3
MNT_DIR=$4
DOMAIN=$5

if [ ! -d "$MNT_DIR" ]; then
  error "Mount point directory does not exists: $MNT_DIR"
  return
fi

ok "Local mount path is: $MNT_DIR"

mode="rw"
# ## Assuming mount point exists already or create first
# ## sudo mkdir $MNT_DIR

# # ## samba dir mounting locally
# # sudo mount -t cifs //$IP/$SHARED_DIR_NAME $MNT_DIR -o username=$USERNAME,domain=$DOMAIN,uid=$(id -u),gid=$(id -g),vers=1.0

# # ## mounting remote linux filesystem over ssh
# # sudo sshfs -o allow_other,default_permissions $USERNAME@$IP:$SHARED_DIR_NAME $MNT_DIR

# # ## Read Only
# # sudo sshfs -o ro,allow_other,default_permissions $USERNAME@$IP:$SHARED_DIR_NAME $MNT_DIR


# ## Much clearner and probably works with fstab entry
# # sudo sshfs -o ro,allow_other,default_permissions,uid=$(id -u),gid=$(id -g) $USERNAME@$IP:$SHARED_DIR_NAME $MNT_DIR
info "sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) $USERNAME@${IP}:$SHARED_DIR_NAME $MNT_DIR"
sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) $USERNAME@${IP}:$SHARED_DIR_NAME $MNT_DIR


# echo "Successfully mounted at: $MNT_DIR"
# echo "changing to mounted dir..."
# echo ""
# echo "For unmounting execute: "
# echo "sudo umount $MNT_DIR"
# echo "Have Fun!"

# cd $MNT_DIR
# # sudo umount $MNT_DIR
