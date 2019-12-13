#!/bin/bash

##----------------------------------------------------------
### Barebone directory structures for Developer toolchain setup
##----------------------------------------------------------
#
### setup - it's re-entrant and idempotent
## i.e. can be executed multiple times with the same behavior and state retured.
## It does not create duplications or side effect
## NOTE:
## It will override any manual changes in the configurations files
#
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------


function codehub_setup() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/codehub.sh

  codehub_main

  create_exports

  create_codehub_dirs

  inject_in_bashrc

  create_config_files
}

codehub_setup
