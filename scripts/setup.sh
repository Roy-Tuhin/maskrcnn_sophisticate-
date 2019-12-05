#!/bin/bash

##----------------------------------------------------------
### Barebone directory structures for Developer toolchain setup
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------

function create_setup() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${SCRIPTS_DIR}/aimldl.setup.sh
  source ${SCRIPTS_DIR}/codehub.setup.sh
}

create_setup
