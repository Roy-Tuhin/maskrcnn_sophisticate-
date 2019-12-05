#!/bin/bash


##----------------------------------------------------------
### Run single item
## created on 24th-Jun-2019
##----------------------------------------------------------
## Usage:
#
## source test_annon_to_db.sh  1>logs/annon_to_db-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
## source test_annon_to_db.sh file 1>logs/annon_to_db-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#
##----------------------------------------------------------

function test_annon_to_db() {
  local prog="${$AI_ANNON_HOME}/annon_to_db.py"
  local cmd="create"

  local from="${AI_ANNON_DATA_HOME_LOCAL}/annotations/"
  local to="${AI_ANNON_DB}"
  # local to="${AI_ANNON_DB_TEST}"

  local releasetype=$1

  if [ -z ${releasetype} ];then
    releasetype='db'
  fi

  if [[ ${releasetype} =~ "file" ]];then
    ## for file based
    echo "--------File based release"
    python ${prog} ${cmd} --from ${from} --to ${to}
  else
    ## for db based
    echo "-------->Database based release"
    python ${prog} ${cmd} --from ${from}
  fi
}

test_annon_to_db $1