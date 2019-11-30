#!/bin/bash

# https://stackoverflow.com/questions/20271101/what-happens-if-you-mount-to-a-non-empty-mount-point-with-fuse


function mount_remote_on_local_paths() {
  local mach_user=$1 ##alpha
  local mach_ip=$2 ##10.4.71.69

  local mach_path=$3 ##/aimldl-dat/logs/mask_rcnn
  local local_path=$4 ##/aimldl-dat/logs/mask_rcnn

  local mode=ro ## read-only
  local mode=rw ## read-write

  ## mount remote syste using sshfs
  ## also mount on nonempty local dir, maps to the local user uid and gid

  echo "mount path: ${local_path}"
  echo "sudo sshfs -o nonempty,${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${mach_user}@${mach_ip}:${mach_path} ${local_path}"

}

mount_remote_on_local_paths $1 $2 $3 $4
