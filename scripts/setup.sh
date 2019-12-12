#!/bin/bash

##----------------------------------------------------------
### Barebone directory structures for Developer toolchain setup
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------

function create_setup() {
  ## codehub created the top level directories for the code including the config
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/codehub.setup.sh
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/aimldl.setup.sh
}

create_setup
