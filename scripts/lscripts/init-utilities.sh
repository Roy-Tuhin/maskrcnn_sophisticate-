#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

##----------------------------------------------------------
## Utilities
##----------------------------------------------------------

source $LSCRIPTS/utils.core.install.sh
source $LSCRIPTS/vim.install.sh
source $LSCRIPTS/sublimetexteditor.install.sh
source $LSCRIPTS/utils.install.sh
source $LSCRIPTS/diff-tools.install.sh
source $LSCRIPTS/haroopad.editor.install.sh
source $LSCRIPTS/adobe-flashplugin.install.sh
## Java
source $LSCRIPTS/java.install.sh
## Python
source $LSCRIPTS/python.install.sh
source $LSCRIPTS/python.virtualenvwrapper.install.sh 3
##
source $LSCRIPTS/php.install.sh
source $LSCRIPTS/apache2.install.sh
##
source $LSCRIPTS/nodejs.install.sh
##
