#!/bin/bash

##----------------------------------------------------------
### Barebone directory structures for AI System setup
##----------------------------------------------------------
#
### setup - it's re-entrant and idempotent
## i.e. can be executed multiple times with the same behavior and state retured.
## It does not create duplications or side effect
## NOTE:
## It will override any manual changes in the configurations files,
## hence, make config changes in following files only:
## config.sh, config.custom.sh, pathy.py, app.py
#
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------


function aimldl_setup() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${SCRIPTS_DIR}/aimldl.sh

  aimldl_main

  create_exports

  inject_in_bashrc

  create_cfg_dir

  create_data_dirs

  create_doc_dirs

  create_local_dirs_for_remote_mount_paths

  create_symlinks

  create_config_files
}

aimldl_setup
