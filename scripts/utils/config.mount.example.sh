
##----------------------------------------------------------
### ## AI System setup - mount
##----------------------------------------------------------
##
##----------------------------------------------------------


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

source "${SCRIPTS_DIR}/config.sh"
source "${SCRIPTS_DIR}/config.custom.sh"

# remote_user="alpha"
# remote_ip="10.4.71.69"
# mount_machprefix="vtq"
# local_mount_path_for_remote_path="${AI_ENVVARS['AI_MNT']}/$mount_machprefix-$remote_machine_id${mount_dir_path}"

##
## sudo sshfs -o nonempty,ro,allow_other,default_permissions,uid=$(id -u),gid=$(id -g) swuser@10.4.71.100:/data/samba/Bangalore/prod/Bangalore_Maze_Exported_Data/ANNOTATIONS /aimldl-mnt/vtq-samba-100/AIML_Annotation

function mnt_annotation_dir() {
  debug "get_mnt_annon_params:============================"

  local remote_path=${AI_ANNON_DATA_HOME}
  local remote_user=$1
  local remote_ip=$2
  local mount_machprefix=$3
  local mode="ro"

  local local_mount_path_for_remote_path=${AI_ENVVARS['AI_DATA']}/data-gaze/AIML_Annotation

  debug "Unmounting if already mounted: ${local_mount_path_for_remote_path}"

  debug "${remote_user} ${remote_ip} ${mount_machprefix} ${mode} ${remote_path} ${local_mount_path_for_remote_path}"
  
  sudo umount ${local_mount_path_for_remote_path}

  mount_sshfs ${remote_user} ${remote_ip} ${mount_machprefix} ${mode} ${remote_path} ${local_mount_path_for_remote_path}
  info "Execute the above command!"

}

## rename this file by replacing 'example' by 'local'
## provide the proper parameters

# $1 is remote system username
# $2 is remote system ip
# $3 local dir prefix example: 'vtq'
mnt_annotation_dir $1 $2 $3