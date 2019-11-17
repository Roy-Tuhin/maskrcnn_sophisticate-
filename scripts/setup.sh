#!/bin/bash

##----------------------------------------------------------
### Barebone directory structures for Developer toolchain setup
##----------------------------------------------------------
## TODO:
##  - to have it's own user and group management
##----------------------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

source "${SCRIPTS_DIR}/codehub.config.sh"

##----------------------------------------------------------
### setup - it's re-entrant and idempotent
## i.e. can be executed multiple times with the same behavior and state retured.
## It does not create duplications or side effect
## NOTE:
## It will override any manual changes in the configurations files
##----------------------------------------------------------

create_exports

create_codehub_dirs

inject_in_bashrc


## TODO: error fix
## [INFO]: ln -s CHUB_ENVVARS[APACHE_HOME] /CHUB_ENVVARS[APACHE_HOME]
## ln: failed to create symbolic link '/CHUB_ENVVARS[APACHE_HOME]': Permission denied

# create_symlinks

create_config_files
