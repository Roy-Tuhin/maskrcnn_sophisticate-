#!/bin/bash

##----------------------------------------------------------
### config - path and other configurations
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------

## CAUTIOUS:
## Ensure that environment variable exports should not have the user name printed in the export script
## Use single quotes to ensure the environment variables does not get expanded

## https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/dockerfiles

source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/system/lscripts.config.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/aimldl.config.sh

local CODEHUB_ENV_FILE=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/config/codehub.env.sh

declare -a CODEHUB_DIRS=(
  "android"
  "apps"
  "apps/www"
  "auth"
  "data"
  "data/database"
  "data/files"
  "data/samples"
  "downloads"
  "external"
  "external4docker"
  "logs"
  "logs/www"
  "logs/www/uploads"
  "practice"
  "readme"
  "samples"
  "scripts"
  "_site"
  "tests"
  "tools"
  "tmp"
  "workspaces"
)

declare -a CH_PY_ENVVARS=(
  'CHUB_APP'
  'CHUB_HOME_EXT'
)

## change CVSUSER to appropriate value, be default uses system user
local CVSUSER=$(whoami)
local CVSSERVER="10.4.71.121"
local CVSPORT="2401"
local CVSROOT=":pserver:${CVSUSER}@${CVSSERVER}:${CVSPORT}/data/CVS_REPO"

## ----
function update_env_file(){
  source ${CODEHUB_ENV_FILE}
  rsync -r ${CODEHUB_ENV_FILE} ${CHUB_CONFIG}
}
