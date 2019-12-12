#!/bin/bash

##----------------------------------------------------------
### external4docker
##----------------------------------------------------------

function create_setup_external4docker() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/codehub.sh
  # codehub_main

  local extdir="/codehub"
  cd ${extdir}
  mkdir -p ${extdir}/external4docker/tensorflow
  git clone https://github.com/tensorflow/tensorflow.git ${extdir}/external4docker/tensorflow
}

create_setup_external4docker
