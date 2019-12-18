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
## aimldl.sh, aimldl.config.sh, paths.py, app.py
#
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------


function aimldl_setup() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/aimldl.sh

  aimldl_main

  create_exports

  inject_in_bashrc

  create_cfg_dir

  create_data_dirs

  create_doc_dirs

  create_local_dirs_for_remote_mount_paths

  create_symlinks

  create_config_files

  create_config_files_aimldl

  echo "${AI_ENVVARS}"
  echo $(lsvirtualenv -b | grep ^py_3 | tr '\n' ',' | cut -d',' -f1)
}

aimldl_setup
