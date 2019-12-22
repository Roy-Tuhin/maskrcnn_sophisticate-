#!/bin/bash

##----------------------------------------------------------
### inkscape
## Tested on Ubuntu 16.04
##----------------------------------------------------------
# https://launchpad.net/~inkscape.dev/+archive/ubuntu/stable


function inkscape_graphics_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [[ ${LINUX_VERSION} == "16.04" ]]; then
    echo "...${LINUX_VERSION}"
    sudo -E add-apt-repository -y ppa:inkscape.dev/stable
    sudo -E apt -y update
  fi

  sudo -E apt -q -y install inkscape
}

inkscape_graphics_install
