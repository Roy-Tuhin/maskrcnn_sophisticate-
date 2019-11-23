#!/bin/bash

##----------------------------------------------------------
### config - path and other configurations, setup functions
##----------------------------------------------------------
#
## Refereces:

## https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash

## variable scopes
## https://stackoverflow.com/questions/30609973/bash-variable-scope-leak
## https://stackoverflow.com/questions/10806357/associative-arrays-are-local-by-default

## What Is /dev/shm And Its Practical Usage?
## https://www.cyberciti.biz/tips/what-is-devshm-and-its-practical-usage.html

# ulimit
## https://www.linuxhowtos.org/tips%20and%20tricks/ulimit.htm
## forkbomb
## https://de.wikipedia.org/wiki/Forkbomb

## Bash Special Variables
## https://stackoverflow.com/questions/5163144/what-are-the-special-dollar-sign-shell-variables#5163260

## Pass parameters to function in a bash script
## https://unix.stackexchange.com/questions/298706/how-to-pass-parameters-to-function-in-a-bash-script

## Case statement
## https://www.thegeekstuff.com/2010/07/bash-case-statement/

## how-to-check-that-a-parameter-was-supplied-to-a-bash-script and function
## https://stackoverflow.com/questions/8968752/how-to-check-that-a-parameter-was-supplied-to-a-bash-script

## Symlink already exists
## https://unix.stackexchange.com/questions/207294/create-symlink-overwrite-if-one-exists
## https://stackoverflow.com/questions/5767062/how-to-check-if-a-symlink-exists

## Unlink/Remove/Delete the symlink
## https://superuser.com/questions/1213217/how-to-unlink-all-the-symlinks-under-the-directory
## https://linux.die.net/man/1/unlink
## unlink is a alias command of rm. therefore rm <symlink> will work same as unlink <symlink>

## Alternative trick to use an-array-as-environment-variable
## https://unix.stackexchange.com/questions/393091/unable-to-use-an-array-as-environment-variable

## Inspired by:
## https://github.com/ApolloAuto/apollo/tree/master/scripts

## Array as sequence
## https://unix.stackexchange.com/questions/199348/dynamically-create-array-in-bash-with-variables-as-array-name

##----------------------------------------------------------


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
source "${SCRIPTS_DIR}/config.custom.sh"

### -------------------------------------------
## Global Variables 
### -------------------------------------------

## Avoid leaking variables in the execution shell

## Reset the global environment variables.
## This makes script re-entrant and side effects can be avoided.
## Otherwise, in the same shell if the script is run again by
## changing the values in config, previous values lingers in the shell.
declare -ga CHUB_DIR_PATHS=()
declare -gA CHUB_ENVVARS=()

function create_envvars() {
  debug "create_envvars:============================"

  ### -------------------------------------------
  ## local Variables 
  ### -------------------------------------------

  ### -------

  declare -a codehub_dirs=(
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
    "scripts"
    "_site"
    "tests"
    "tools"
    "cfg"
    "workspaces"
  )

  declare -a ch_py_envvars=(
    'CHUB_APP'
    'CHUB_HOME_EXT'
  )

  ## CAUTIOUS:
  ## Ensure that environment variable exports should not have the user name printed in the export script
  ## Use single quotes to ensure the environment variables does not get expanded
  CHUB_ENVVARS['APACHE_HOME']='${HOME}/public_html'

  CHUB_ENVVARS['LINUX_SCRIPT_HOME']="${LINUX_SCRIPT_HOME}"

  CHUB_ENVVARS['ANDROID_HOME']="${ANDROID_HOME}"
  CHUB_ENVVARS['CVSROOT']="${CVSROOT}"

  CHUB_ENVVARS['CHUB_VM_HOME']="${VM_HOME}"
  CHUB_ENVVARS['CHUB_PY_VENV_PATH']="${PY_VENV_PATH}"
  CHUB_ENVVARS['CHUB_WSGIPythonPath']="${WSGIPYTHONPATH}"
  CHUB_ENVVARS['CHUB_WSGIPythonHome']="${WSGIPYTHONHOME}"

  CHUB_ENVVARS['CHUB_HOME']="${CHUB_HOME}"

  CHUB_ENVVARS['CHUB_CFG']="${CHUB_ENVVARS['CHUB_HOME']}/cfg"
  CHUB_ENVVARS['CHUB_DATA']="${CHUB_ENVVARS['CHUB_HOME']}/data"
  CHUB_ENVVARS['CHUB_HOME_EXT']="${CHUB_ENVVARS['CHUB_HOME']}/external"
  CHUB_ENVVARS['CHUB_DOWNLOADS']="${CHUB_ENVVARS['CHUB_HOME']}/downloads"
  CHUB_ENVVARS['CHUB_WORKSPACES']="${CHUB_ENVVARS['CHUB_HOME']}/workspaces"

  CHUB_ENVVARS['CHUB_APP']="${CHUB_ENVVARS['CHUB_HOME']}/apps"
  CHUB_ENVVARS['CHUB_WEB_APP']="${CHUB_ENVVARS['CHUB_HOME']}/apps/www"

  CHUB_ENVVARS['CHUB_LOGS']="${CHUB_ENVVARS['CHUB_HOME']}/logs"
  CHUB_ENVVARS['CHUB_WEB_APP_LOGS']="${CHUB_ENVVARS['CHUB_LOGS']}/www"
  CHUB_ENVVARS['CHUB_WEB_APP_UPLOADS']="${CHUB_ENVVARS['CHUB_HOME']}/www/uploads"

  ### -------

  CHUB_ENVVARS['CHUB_GOOGLE_APPLICATION_CREDENTIALS']=\""${CHUB_ENVVARS['CHUB_HOME']}/auth/${google_application_credentials_file}\""
  
  ### -------

  ## TODO: if the environment varaibles are present in custom config file, then override the default values created here
  CHUB_ENVVARS['CHUB_PY_ENVVARS']=$(IFS=:; printf '%s' "${ch_py_envvars[*]}")

  ### -------
  local codehubdir
  # for ((i=0; i<${#codehub_dirs[@]}; ++i)) ; do
  for i in ${!codehub_dirs[*]}; do
    codehubdir="${codehub_dirs[$i]}"
    info "$i===>${CHUB_ENVVARS['CHUB_HOME']}/${codehubdir}"
    CHUB_DIR_PATHS[$i]="${CHUB_ENVVARS['CHUB_HOME']}/${codehubdir}"
  done
  debug "CHUB_DIR_PATHS: ${CHUB_DIR_PATHS[*]}"
}


##----------------------------------------------------------
### function for creating required directory structures
##----------------------------------------------------------

function create_base_paths() {
  debug "create_base_paths:============================: $1"

  case "$1" in
    "codehub")
      local codehub_base_path=${CHUB_ENVVARS['CHUB_HOME']}
      ok "codehub_base_path: ${codehub_base_path}"
      if [ ! -d ${codehub_base_path} ]; then
        sudo mkdir -p ${codehub_base_path}
        touch ${codehub_base_path}/.gitkeep
        sudo chown -R $(id -un):$(id -gn) ${codehub_base_path}
      fi
      ;;
    *)
      echo "Unknown option to create_base_paths function!"
      ;;
  esac
}


function create_codehub_dirs() {
  debug "create_codehub_dirs:============================"

  create_base_paths "codehub"

  local codehub_dir_path
  for i in ${!CHUB_DIR_PATHS[*]}; do
    codehub_dir_path=${CHUB_DIR_PATHS[$i]}
    info "$i--->${codehub_dir_path}"
    if [ ! -d ${codehub_dir_path} ]; then
      sudo mkdir -p ${codehub_dir_path}
      sudo chown -R $(id -un):$(id -gn) ${codehub_dir_path}
    fi
  done
}


function __copy_config_files__() {
  debug "__copy_config_files__:============================"
  debug ${CHUB_ENVVARS}
  debug ${CHUB_ENVVARS['CHUB_CFG']}
  rsync -r ${SCRIPTS_DIR}/config/* ${CHUB_ENVVARS['CHUB_CFG']}
  ls -ltr ${CHUB_ENVVARS['CHUB_CFG']}
}


function create_exports() {
  debug 'create_exports:============================'

  local env
  local _line
  local export_file="${SCRIPTS_DIR}/config/export.sh"
  
  echo "#!/bin/bash" > $export_file
  for env in "${!CHUB_ENVVARS[@]}"; do
    _line="export ${env}"=${CHUB_ENVVARS[$env]}
    echo "${_line}" >> ${export_file}
  done

  local CHUB_ENVVARS=$(IFS=:; printf '%s' "${!CHUB_ENVVARS[*]}")

  # echo 'export PYTHONPATH=${PYTHONPATH}' >> ${export_file}
  echo "export CHUB_ENVVARS=${CHUB_ENVVARS}" >> ${export_file}

  source ${export_file}
}


function inject_in_bashrc() {
  FILE=${HOME}/.bashrc
  echo "Modifying ${FILE}"
  LINE="source ${CHUB_ENVVARS['CHUB_CFG']}/codehub.env.sh"
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}


function create_symlinks() {
  debug 'create_symlinks:============================'

  declare -a symlinks=(
    CHUB_ENVVARS['APACHE_HOME']
  )

  for slink in "${symlinks[@]}"; do
    slink_dir=${CHUB_ENVVARS['CHUB_HOME']}/$(echo ${slink} | cut -d'-' -f 2)
    if [ ! -L "${slink_dir}" ]; then
      echo "creating..."
      info ln -s ${slink} ${slink_dir}
      ln -s ${slink} ${slink_dir}
    else
      info Already Exists: ln -s ${slink} ${slink_dir}
    fi
    # ln -s ${slink} ${slink_dir}
  done
}


function create_config_files() {
  __copy_config_files__
}

##----------------------------------------------------------
### create and export environment variables
##----------------------------------------------------------

create_envvars
