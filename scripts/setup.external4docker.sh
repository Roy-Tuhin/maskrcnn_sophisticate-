#!/bin/bash

##----------------------------------------------------------
### external4docker
##----------------------------------------------------------


function create_setup_external4docker() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/codehub.sh
  # codehub_main

  local extdir="/codehub/external4docker"
  cd ${extdir}
  mkdir -p ${extdir}/tensorflow
  git clone https://github.com/tensorflow/tensorflow.git ${extdir}/tensorflow
}

create_setup_external4docker
