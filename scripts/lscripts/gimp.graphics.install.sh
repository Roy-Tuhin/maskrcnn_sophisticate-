#!/bin/bash

##----------------------------------------------------------
### gimp
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

## Gimp
# http://ubuntuhandbook.org/index.php/2015/11/how-to-install-gimp-2-8-16-in-ubuntu-16-04-15-10-14-04/


function gimp_graphics_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [[ ${LINUX_VERSION} == "16.04" ]]; then
    echo "...${LINUX_VERSION}"
    ### Uninstall.
    ##sudo -E apt -q -y install ppa-purge
    ##sudo ppa-purge ppa:otto-kesselgulasch/gimp

    sudo -E add-apt-repository -y ppa:otto-kesselgulasch/gimp
    sudo -E apt -y update
  fi

  sudo -E apt -q -y install gimp
}

gimp_graphics_install
