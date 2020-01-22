#!/bin/bash

function dir_to_link() {
  echo "Enter the direcorty to move and replace it with a symlink:"
  read this_dir

  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  local that_dir=${this_dir}-${timestamp}

  if [ -d ${this_dir} ]; then
    mv ${this_dir} ${that_dir}
    ln -s ${that_dir} ${this_dir}
  fi
}

dir_to_link
