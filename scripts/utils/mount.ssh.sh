#!/bin/bash

# https://stackoverflow.com/questions/20271101/what-happens-if-you-mount-to-a-non-empty-mount-point-with-fuse


function mount_remote_on_local_paths() {

  ## AI Annotations
  # local ai_mach_user=swuser
  # local ai_mach_ip=10.4.71.100
  # local ai_mach_path=/data/samba/Bangalore/prod/Bangalore_Maze_Exported_Data/ANNOTATIONS
  # local ai_local_path=/aimldl-mnt/vtq-samba-100/AIML_Annotation
  # local mode=ro
  # sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${ai_mach_user}@${ai_mach_ip}:${ai_mach_path} ${ai_local_path}


  ## AI Dev Machine Mount on local

  ## Dev-69
  local ai_mach_user=alpha
  local ai_mach_ip=10.4.71.69

  local ai_mach_path=/aimldl-dat/logs/mask_rcnn
  local ai_local_path=/aimldl-dat/logs/mask_rcnn
  local mode=rw
  sudo sshfs -o nonempty,${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${ai_mach_user}@${ai_mach_ip}:${ai_mach_path} ${ai_local_path}

  echo "mount path: ${ai_local_path}"

  local ai_mach_path=/aimldl-dat/data-gaze
  local ai_local_path=${ai_mach_path}
  local mode=rw
  sudo sshfs -o nonempty,${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${ai_mach_user}@${ai_mach_ip}:${ai_mach_path} ${ai_local_path}

  echo "mount path: ${ai_local_path}"
}

mount_remote_on_local_paths
