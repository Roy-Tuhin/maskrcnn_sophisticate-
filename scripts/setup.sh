#!/bin/bash

##----------------------------------------------------------
### Barebone directory structures for Developer toolchain setup
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------

function create_setup() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

  ## codehub created the top level directories for the code including the config
  source ${SCRIPTS_DIR}/codehub.setup.sh
  source ${SCRIPTS_DIR}/aimldl.setup.sh
}

create_setup
