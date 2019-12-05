#!/bin/bash

usage(){
  echo "Usage :
  [-d database name]
  [-k host db ip address]
  [-p host db port number]
  [-r ROOT path] [-help Usage]";
}

while getopts ":d:k:p:r:" options; do
  case "${options}" in
    d)
        d=${OPTARG}
        ;;
    k)
        k=${OPTARG}
        ;;
    p)
        p=${OPTARG}
        ;;
    r)
        r=${OPTARG}
        ;;
    help | *)
        usage
        return 0
        ;;
  esac
done
shift $((OPTIND-1))

# echo ${OPTARG}

# echo "db_name = ${d}"
# echo "host = ${h}"
# echo "port_number = ${p}"
# echo "ROOT = ${r}"

# if [ -z ${db} ${h} ${p} ${r}]; then
#   usage
#   return 0
# fi

db_name=${d}
host=${k}
port_number=${p}
ROOT=${r}

# echo ${host}
# echo ${h}

function endtoend(){

  # if [ -z ${db_name} ]; then
  #   echo "Database name is missing!"
  #   return
  # fi

  if [ ! -z ${db_name} ]; then
    db_str="-p db_name ${db_name} "
  else db_str=""
  fi
  #

  # echo ${host}
  # echo ${k}

  if [ ! -z ${host} ]; then
    host_str="-p host ${host} "
  else host_str=""
  fi

  # echo ${host_str}

  #
  if [ ! -z ${port_number} ]; then
    port_str="-p port_number ${port_number} "
  else port_str=""
  fi
  #
  if [ ! -z ${ROOT} ]; then
    root_str="-p ROOT ${ROOT}"and
  else root_str=""
  fi

  str=${db_str}${host_str}${port_str}${root_str}

  # echo ${str}

  local output_path=${HOME}/Desktop/test/
  local timestamp=$(date -d now +'%d%m%y_%H%M%S')
  # local prog =${AI_ANNON_HOME}/e2e_viz.ipynb

  # if [ -f ${ROOT} ]; then
  #   return local p_root=-p ${ROOT}
  #
  # if [ -f ${host} ]; then
  #   return local p_host=-p ${host}
  #
  # if [ -f ${port_number} ]; then
  #   return local p_port_number=-p ${port_number}
  #
  # if [ -f ${db_name} ]; then
  #   return local p_db_name=-p ${db_name}


  echo papermill e2e_viz.ipynb ${output_path}output_${timestamp}.ipynb ${str}
  papermill e2e_viz.ipynb ${output_path}output_${timestamp}.ipynb ${str}

}

endtoend
