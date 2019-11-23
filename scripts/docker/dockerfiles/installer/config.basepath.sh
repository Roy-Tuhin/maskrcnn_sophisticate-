#!/bin/bash

##----------------------------------------------------------
### Basepath configuration
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

CHUB_DIR="codehub"
CHUB_HOME="/${CHUB_DIR}"

# BASEDIR="softwares"
# BASEPATH="${HOME}/${BASEDIR}"

BASEDIR="external"
BASEPATH="${CHUB_HOME}/${BASEDIR}"

DOCKER_BASEPATH="/external4docker"
