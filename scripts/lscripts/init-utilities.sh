#!/bin/bash



function init_utilities() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
    ##----------------------------------------------------------
  ## Utilities
  ##----------------------------------------------------------

  source ${LSCRIPTS}/utils.core.install.sh
  source ${LSCRIPTS}/vim.install.sh
  source ${LSCRIPTS}/sublimetexteditor.install.sh
  source ${LSCRIPTS}/utils.install.sh
  source ${LSCRIPTS}/diff-tools.install.sh
  source ${LSCRIPTS}/haroopad.editor.install.sh
  source ${LSCRIPTS}/adobe-flashplugin.install.sh
  ## Java
  source ${LSCRIPTS}/java.install.sh
  ## Python
  source ${LSCRIPTS}/python.install.sh
  source ${LSCRIPTS}/python.virtualenvwrapper.install.sh 3
  ##
  source ${LSCRIPTS}/php.install.sh
  source ${LSCRIPTS}/apache2.install.sh
  ##
  source ${LSCRIPTS}/nodejs.install.sh
  ##
}

init_utilities
