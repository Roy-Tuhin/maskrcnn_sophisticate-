#!/bin/bash

function copy_job_from_ro_mount_to_data_dir() {
  local ai_local_path=/aimldl-mnt/vtq-samba-100/AIML_Annotation
  local copy_aiannon_to=/aimldl-dat/data-gaze/AIML_Annotation

  local SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  ## this umount and mount the remote annotations path to local path
  source ${SCRIPTS_DIR}/mount.ssh-aiannotations.sh

  ## once mount is done, show the list of annotation directories / job ids to copy locally
  ## prompt the user the directory name to copy, and use that to copy it locally
  local dir_name
  ls -ltrh ${ai_local_path}
  echo "Enter the directory name to copy locally:"
  read dir_name  

  if [ -z ${dir_name} ]; then
    echo "dir_name: ${dir_name} cannot be empty"
    return
  fi

  local dirpath_from=${ai_local_path}/${dir_name}
  if [ ! -d ${dirpath_from} ]; then
    echo "dirpath_from: ${dirpath_from} does not exist"
    echo "check following..."
    echo "Remote Annotations are mounted locally at: ${ai_local_path}"
    echo "Job ID directory i.e. dir_name exists or not: ${dir_name}"
    return
  fi

  local dirpath_to=${copy_aiannon_to}/${dir_name}
  ## do not copy is local directory is already present
  if [ -d ${dirpath_to} ]; then
    echo "dirpath_to: ${dirpath_to} already exists. Copy it manually if you want to override!"
    return
  fi

  echo "Copying ${dir_name} to local system at: ${copy_aiannon_to}"
  echo "cp -R ${dirpath_from} ${dirpath_to}"
  # cp -R ${dirpath_from} ${dirpath_to}
}

copy_job_from_ro_mount_to_data_dir
