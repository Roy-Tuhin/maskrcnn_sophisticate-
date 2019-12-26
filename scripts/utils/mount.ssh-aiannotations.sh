#!/bin/bash


## Ref:
## https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
## empty dir check: ls -A /path/to/dir


## Quick command string:
## sudo sshfs -o nonempty,ro,allow_other,default_permissions,uid=$(id -u),gid=$(id -g) swuser@10.4.71.100:/data/samba/Bangalore/prod/Bangalore_Maze_Exported_Data/ANNOTATIONS /aimldl-mnt/vtq-samba-100/AIML_Annotation

## TODO:
## check for already mounted or not:
## - empty dir check or
## - unmount before mounting again

function mount_remote_aiannotations_on_local_paths() {

  ## AI Annotations
  local ai_mach_user=swuser
  local ai_mach_ip=10.4.71.100
  local ai_mach_path=/data/samba/Bangalore/prod/Bangalore_Maze_Exported_Data/ANNOTATIONS
  local ai_local_path=/aimldl-mnt/vtq-samba-100/AIML_Annotation
  local mode=ro

  echo "Unmounting before mounting again: ${ai_local_path}"
  sudo umount ${ai_local_path}

  echo "mounting remote annotations locally. Executing following cmd..."
  echo "sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${ai_mach_user}@${ai_mach_ip}:${ai_mach_path} ${ai_local_path}"
  sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${ai_mach_user}@${ai_mach_ip}:${ai_mach_path} ${ai_local_path}

  echo "mount path: ${ai_local_path}"
}

mount_remote_aiannotations_on_local_paths
