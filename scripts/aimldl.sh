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


function aimldl_main() {

  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/lscripts/utils/common.sh
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/aimldl.config.sh

  ## Avoid leaking variables in the execution shell

  ## Reset the global environment variables.
  ## This makes script re-entrant and side effects can be avoided.
  ## Otherwise, in the same shell if the script is run again by
  ## changing the values in config, previous values lingers in the shell.
  declare -gA AI_ENVVARS=()
  declare -ga AI_DATA_DIR_PATHS=()
  declare -ga AI_CFG_PATHS=()
  declare -gA AI_MOUNT_PATHS_FOR_REMOTE=()

  ## TODO: check if the top level directory can be provided as env variables itself
  # declare -gA AI_DOC_DIR_PATHS=()
  # declare -gA AI_CFG_DIR_PATHS=()

  function create_envvars() {
    debug "create_envvars:============================"

    ### -------------------------------------------
    ## local Variables 
    ### -------------------------------------------

    local ai_basepath=${AI_BASEPATH}
    local ai_vm_base=${AI_VM_BASE}
    local ai_prefix=${AI_DIR_PREFIX}
    local ai_weights_path=${AI_WEIGHTS_PATH}
    local ai_mount_machprefix=${AI_MOUNT_MACHPREFIX}
    local ai_google_application_credentials_file=${AI_GOOGLE_APPLICATION_CREDENTIALS_FILE}

    local ai_wsgipythonpath=${AI_WSGIPythonPath}
    local ai_wsgipythonhome=${AI_WSGIPythonHome}

    ## Top Level Directories
    local ai_code_base_path=${AI_CODE_BASE_PATH}
    local ai_cfg_base_path=${AI_CFG_BASE_PATH}
    local ai_data_base_path=${AI_DATA_BASE_PATH}
    local ai_mount_base_path=${AI_MOUNT_BASE_PATH}
    local ai_doc_base_path=${AI_DOC_BASE_PATH}
    local ai_rpt_base_path=${AI_RPT_BASE_PATH}
    local ai_kbank_base_path=${AI_KBANK_BASE_PATH}
    ### -------

    declare -a ai_remote_machine_ids=(${AI_REMOTE_MACHINE_IDS[@]})

    declare -a ai_cfg_dirs=(${AI_CFG_DIRS[@]})

    declare -a ai_data_dirs=(${AI_DATA_DIRS[@]})

    declare -a ai_py_envvars=(${AI_PY_ENVVARS[@]})

    ## CAUTIOUS:
    ## Ensure that environment variable exports should not have the user name printed in the export script
    ## Use single quotes to ensure the environment variables does not get expanded
    AI_ENVVARS['APACHE_HOME']='${HOME}/public_html'

    AI_ENVVARS['AI_VM_HOME']=${AI_VM_HOME}
    AI_ENVVARS['AI_PY_VENV_PATH']=${AI_PY_VENV_PATH}
    AI_ENVVARS['WORKON_HOME']=${WORKON_HOME}

    AI_ENVVARS['AI_PYVER']=${AI_PYVER}
    AI_ENVVARS['AI_PY_VENV_NAME']=${AI_PY_VENV_NAME}

    AI_ENVVARS['AI_WSGIPythonPath']=${AI_PY_VENV_PATH}/${ai_wsgipythonpath}
    AI_ENVVARS['AI_WSGIPythonHome']=${AI_PY_VENV_PATH}/${ai_wsgipythonhome}

    AI_ENVVARS['AI_CFG']="${ai_cfg_base_path}"
    AI_ENVVARS['AI_MODEL_CFG_PATH']="${AI_ENVVARS['AI_CFG']}/model"

    AI_ENVVARS['AI_DOC']="${ai_doc_base_path}"
    AI_ENVVARS['AI_DATA']="${ai_data_base_path}"
    AI_ENVVARS['AI_HOME']="${ai_code_base_path}"
    AI_ENVVARS['AI_MNT']="${ai_mount_base_path}"

    AI_ENVVARS['AI_REPORTS']="${ai_rpt_base_path}"
    AI_ENVVARS['AI_KBANK']="${ai_kbank_base_path}"

    AI_ENVVARS['AI_WEIGHTS_PATH']="${AI_ENVVARS['AI_DATA']}/${ai_weights_path}"

    ## TODO: merge duplicate path variable usage to single variable
    AI_ENVVARS['AI_LOGS']="${AI_ENVVARS['AI_DATA']}/logs"
    # AI_ENVVARS['LOG_DIR']="${AI_ENVVARS['AI_DATA']}/logs"

    AI_ENVVARS['AI_SCRIPTS']="${AI_ENVVARS['AI_HOME']}/scripts"
    AI_ENVVARS['AI_APP']="${AI_ENVVARS['AI_HOME']}/apps"
    AI_ENVVARS['AI_ANNON_HOME']="${AI_ENVVARS['AI_HOME']}/apps/annon"

    AI_ENVVARS['AI_CONFIG']="${AI_ENVVARS['AI_HOME']}/config"

    AI_ENVVARS['AI_WEB_APP']="${AI_ENVVARS['AI_HOME']}/apps/www"
    AI_ENVVARS['AI_WEB_APP_LOGS']="${AI_ENVVARS['AI_LOGS']}/www"
    AI_ENVVARS['AI_WEB_APP_UPLOADS']="${AI_ENVVARS['AI_HOME']}/www/uploads"

    AI_ENVVARS['AI_HOME_EXT']="${AI_ENVVARS['AI_HOME']}/external"

    AI_ENVVARS['FASTER_RCNN']="${AI_ENVVARS['AI_HOME_EXT']}/py-faster-rcnn"
    AI_ENVVARS['CAFFE_ROOT']="${AI_ENVVARS['AI_HOME_EXT']}/py-faster-rcnn/caffe-fast-rcnn"
    AI_ENVVARS['MASK_RCNN']="${AI_ENVVARS['AI_HOME_EXT']}/Mask_RCNN"
    AI_ENVVARS['AI_LANENET_ROOT']="${AI_ENVVARS['AI_HOME_EXT']}/lanenet-lane-detection"

    ### -------

    AI_ENVVARS['AI_GOOGLE_APPLICATION_CREDENTIALS']=\""${AI_ENVVARS['AI_HOME']}/auth/${ai_google_application_credentials_file}\""
    
    ### -------

    ## TODO: if the environment varaibles are present in custom config file, then override the default values created here
    AI_ENVVARS['AI_ANNON_DATA_HOME']="${AI_ANNON_DATA_HOME}"
    AI_ENVVARS['AI_ANNON_DATA_HOME_LOCAL']="${AI_ANNON_DATA_HOME_LOCAL}"
    AI_ENVVARS['AI_ANNON_DB']="${AI_ANNON_DB}"

    AI_ENVVARS['AI_PY_ENVVARS']=$(IFS=:; printf '%s' "${ai_py_envvars[*]}")

    ### -------
    local cfgdir
    for i in ${!ai_cfg_dirs[*]}; do
      cfgdir="${ai_cfg_dirs[$i]}"
      info "$i===>${AI_ENVVARS['AI_CFG']}/${cfgdir}"
      AI_CFG_PATHS[$i]="${AI_ENVVARS['AI_CFG']}/${cfgdir}"
    done
    debug "AI_CFG_PATHS: ${AI_CFG_PATHS[*]}"

    local ddir
    for i in ${!ai_data_dirs[*]}; do
      ddir="${ai_data_dirs[$i]}"
      info "$i===>${AI_ENVVARS['AI_DATA']}/${ddir}"
      AI_DATA_DIR_PATHS[$i]="${AI_ENVVARS['AI_DATA']}/${ddir}"
    done
    debug "AI_DATA_DIR_PATHS: ${AI_DATA_DIR_PATHS[*]}"

    local remote_mnt_path
    for machine_id in "${ai_remote_machine_ids[@]}"; do
      # debug "${machine_id}"
      remote_mnt_path="${AI_ENVVARS['AI_MNT']}/${ai_mount_machprefix}-${machine_id}"
      info "${remote_mnt_path}"
      AI_MOUNT_PATHS_FOR_REMOTE["${machine_id}"]="${remote_mnt_path}"
    done
    debug "AI_MOUNT_PATHS_FOR_REMOTE: ${AI_MOUNT_PATHS_FOR_REMOTE[@]}"
    ### -------
  }

  ##----------------------------------------------------------
  ### function for creating required directory structures
  ##----------------------------------------------------------

  function create_base_paths() {
    debug "create_base_paths:============================: $1"
    case "$1" in
      "data")
        local ai_data_base_path=${AI_ENVVARS['AI_DATA']}
        ok "ai_data_base_path: ${ai_data_base_path}"
        if [ ! -d ${ai_data_base_path} ]; then
          sudo mkdir -p ${ai_data_base_path}
          sudo chown -R $(id -un):$(id -gn) ${ai_data_base_path}
        fi
        ;;
      "mnt")
        local ai_mount_base_path=${AI_ENVVARS['AI_MNT']}
        ok "ai_mount_base_path: ${ai_mount_base_path}"
        if [ ! -d ${ai_mount_base_path} ]; then
          sudo mkdir -p ${ai_mount_base_path}
          sudo chown -R $(id -un):$(id -gn) ${ai_mount_base_path}
        fi
        ;;
      "cfg")
        local ai_cfg_base_path=${AI_ENVVARS['AI_CFG']}
        ok "ai_cfg_base_path: ${ai_cfg_base_path}"
        if [ ! -d ${ai_cfg_base_path} ]; then
          sudo mkdir -p ${ai_cfg_base_path}
          sudo chown -R $(id -un):$(id -gn) ${ai_cfg_base_path}
        fi
        ;;
      "doc")
        local ai_doc_base_path=${AI_ENVVARS['AI_DOC']}
        ok "ai_doc_base_path: ${ai_doc_base_path}"
        if [ ! -d ${ai_doc_base_path} ]; then
          sudo mkdir -p ${ai_doc_base_path}
          sudo chown -R $(id -un):$(id -gn) ${ai_doc_base_path}
        fi
        ;;
      "rpt")
        local ai_rpt_base_path=${AI_ENVVARS['AI_REPORTS']}
        ok "ai_rpt_base_path: ${ai_rpt_base_path}"
        if [ ! -d ${ai_rpt_base_path} ]; then
          sudo mkdir -p ${ai_rpt_base_path}
          sudo chown -R $(id -un):$(id -gn) ${ai_rpt_base_path}
        fi
        ;;
      "kbk")
        local ai_kbank_base_path=${AI_ENVVARS['AI_KBANK']}
        ok "ai_kbank_base_path: ${ai_kbank_base_path}"
        if [ ! -d ${ai_kbank_base_path} ]; then
          sudo mkdir -p ${ai_kbank_base_path}
          sudo chown -R $(id -un):$(id -gn) ${ai_kbank_base_path}
        fi
        ;;
      *)
        echo "Unknown option to create_base_paths function!"
        ;;
    esac
  }


  function create_cfg_dir() {
    debug "create_cfg_dir:============================"

    create_base_paths "cfg"
    local cfg_dir_path
    for i in ${!AI_CFG_PATHS[*]}; do
      cfg_dir_path=${AI_CFG_PATHS[$i]}
      info "$i--->${cfg_dir_path}"
      if [ ! -d ${cfg_dir_path} ]; then
        sudo mkdir -p ${cfg_dir_path}
        sudo chown -R $(id -un):$(id -gn) ${cfg_dir_path}
      fi
    done
  }

  function create_data_dirs() {
    debug "create_data_dirs:============================"

    create_base_paths "data"

    local data_dir_path
    for i in ${!AI_DATA_DIR_PATHS[*]}; do
      data_dir_path=${AI_DATA_DIR_PATHS[$i]}
      info "$i--->${data_dir_path}"
      if [ ! -d ${data_dir_path} ]; then
        sudo mkdir -p ${data_dir_path}
        sudo chown -R $(id -un):$(id -gn) ${data_dir_path}
      fi

      local match="mongodb"
      if [[ ${data_dir_path} =~ ${match} ]];then
        sudo chown -R mongodb:mongodb ${data_dir_path}
      fi
    done
  }


  function create_doc_dirs() {
    debug "create_doc_dirs:============================"

    create_base_paths "doc"
    create_base_paths "rpt"
    create_base_paths "kbk"
  }


  function create_local_dirs_for_remote_mount_paths() {
    debug "create_local_dirs_for_remote_mount_paths:============================"
    
    create_base_paths "mnt"

    local mount_paths_for_remote
    for mount_paths_for_remote in "${AI_MOUNT_PATHS_FOR_REMOTE[@]}"; do
      info ${mount_paths_for_remote}
      if [ ! -d ${mount_paths_for_remote} ]; then
        sudo mkdir -p ${mount_paths_for_remote}
        sudo chown -R $(id -un):$(id -gn) ${mount_paths_for_remote}
      fi
    done
  }


  function mount_sshfs() {
    debug "mount_sshfs:============================: $1, $2, $3, $4, $5, $6"

    ## TODO: check for mandatory input parameters
    local remote_user=$1
    local remote_ip=$2
    local ai_mount_machprefix=$3
    local mode=$4
    local remote_path=$5
    local local_mount_path_for_remote_path=$6

    if (( $# != 6 ));then
      error "Required input parameters are missing!"
      info "Usage: mount_sshfs <remote_user> <remote_ip> <ai_mount_machprefix> <mode> <remote_path> <local_mount_path_for_remote_path>"
      return
    fi

    ## Ref: https://stackoverflow.com/questions/9018723/what-is-the-simplest-way-to-remove-a-trailing-slash-from-each-parameter
    ## remote_path=$(echo $remote_path | sed 's:/*$::' | rev | cut -d'/' -f1 | rev)

    if [ ! -z "$remote_path" -a "$remote_path" == " " ]; then
      error "remote_path is empty or '/'"
      return
    fi
    
    if [ ! -d ${local_mount_path_for_remote_path} ]; then
      info "Path does not exist, trying to create: ${local_mount_path_for_remote_path}"
      
      create_base_paths "mnt"

      sudo mkdir -p ${local_mount_path_for_remote_path}
      sudo chown -R $(id -un):$(id -gn) ${local_mount_path_for_remote_path}

      if [ $? -ne 0 ];then
          error "Failed to create path : ${local_mount_path_for_remote_path}"
          # exit 1
          return
      fi
      ok "Path created: ${local_mount_path_for_remote_path}"
    fi

    # info "mounting using sshfs..."
    ## mode can be: "ro" - read-only or "rw" - read-write
    local mntcmd="sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${remote_user}@${remote_ip}:${remote_path} ${local_mount_path_for_remote_path}"
    # sudo sshfs -o ${mode},allow_other,default_permissions,uid=$(id -u),gid=$(id -g) ${remote_user}@${remote_ip}:${remote_path} ${local_mount_path_for_remote_path}

    echo -e $mntcmd
  }


  function create_exports() {
    debug "create_exports:============================:"

    local env
    local _line
    local export_file=${AI_ENVVARS['AI_SCRIPTS']}/config/aimldl.export.sh
    
    info "export_file: ${export_file}"

    echo "#!/bin/bash" > ${export_file}
    for env in "${!AI_ENVVARS[@]}"; do
      _line="export ${env}"=${AI_ENVVARS[${env}]}
      info ${_line}
      echo "${_line}" >> ${export_file}
    done

    local ai_envvars=$(IFS=:; printf '%s' "${!AI_ENVVARS[*]}")

    echo 'export PYTHONPATH=${PYTHONPATH}:${CAFFE_ROOT}/python' >> ${export_file}
    echo "export AI_ENVVARS=${ai_envvars}" >> ${export_file}

    source ${export_file}
  }


  function inject_in_bashrc() {
    FILE=${HOME}/.bashrc
    echo "Modifying ${FILE}"
    LINE="source ${AI_ENVVARS['AI_CONFIG']}/aimldl.env.sh"
    grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
  }


  function create_symlinks() {
    debug 'create_symlinks:============================:'

    declare -a symlinks=(
      ${AI_ENVVARS['AI_DATA']}
      ${AI_ENVVARS['AI_MNT']}
      ${AI_ENVVARS['AI_DOC']}
      ${AI_ENVVARS['AI_REPORTS']}
      ${AI_ENVVARS['AI_KBANK']}
    )

    for slink in "${symlinks[@]}"; do
      slink_dir=${AI_ENVVARS['AI_HOME']}/$(echo ${slink} | cut -d'-' -f 2)
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


  function create_config_files_aimldl() {
    local pyver=${AI_PYVER}
    local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)

    debug "${pyver}, ${pyenv}"

    workon ${pyenv}

    python ${AI_ENVVARS['AI_SCRIPTS']}/paths.py
    python ${AI_ENVVARS['AI_SCRIPTS']}/app.py
  }


  function __copy_config_files__() {
    debug "__copy_config_files__:============================"
    debug ${AI_ENVVARS['AI_CONFIG']}
    rsync -r ${AI_ENVVARS['AI_SCRIPTS']}/config/* ${AI_ENVVARS['AI_CONFIG']}
    ls -ltr ${AI_ENVVARS['AI_CONFIG']}
  }


  function create_config_files() {
    __copy_config_files__
  }

  ##----------------------------------------------------------
  ### create and export environment variables
  ##----------------------------------------------------------

  create_envvars
}

