#!/bin/bash

function get_git_urls() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )
  # echo ${LSCRIPTS}

  ## ls -d $PWD/*
  local basepath_dir=/aimldl-cod/external

  local basepath_dir=/codehub/external
  declare DIR_ARRAY=($(ls -d ${basepath_dir}/*))

  ## local FILE="/codehub/tmp/aimldlcod.external.jarvis.sh"
  ## local FILE=/codehub/tmp/$(date +"%d%m%y_%H%M%S-%N_XXXXXX")-external.sh
  ## mktemp ${FILE}

  local FILE=${LSCRIPTS}/setup.external-full.sh

  touch ${FILE}
  ls -ltr ${FILE}

  echo "DIR_ARRAY: ${DIR_ARRAY[@]}"
  echo "==========================="

  echo "FILE: ${FILE}"
  echo "==========================="
  for repo in "${DIR_ARRAY[@]}"; do
    cd ${repo}
    local LINE=$(echo "git clone https:"$(git remote -v | grep -i fetch | cut -d':' -f2 | cut -d' ' -f1))
    echo "${LINE}"
    grep -qF "${LINE}" "${FILE}" || echo "${LINE}" >> "${FILE}"
  done

  cd ${LSCRIPTS}
}

get_git_urls
