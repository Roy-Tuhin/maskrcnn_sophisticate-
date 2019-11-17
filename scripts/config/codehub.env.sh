#!/bin/bash

## TODO: Instead of echo to .bashrc, echo it in this file

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

source ${SCRIPTS_DIR}/export.sh
source ${SCRIPTS_DIR}/ps1.sh

## commands
alias lt='ls -lrth'
alias gccselect='source ${LINUX_SCRIPT_HOME}/utils/gcc-select.sh'
alias getip='source ${LINUX_SCRIPT_HOME}/utils/ip.sh'

## change directory
alias lscripts="cd ${LINUX_SCRIPT_HOME}"
alias chub="cd ${CHUB_HOME}"

alias technotes='cd ${CHUB_HOME}/technotes'

alias chubdata="cd ${CHUB_DATA}"
alias chublogs="cd ${CHUB_LOGS}"

## util scripts
alias androidstudio="bash ${CHUB_HOME}/tools/android-studio/bin/studio.sh"
### CVS
alias cvstt='cvs status 2>/dev/null | grep ^File | grep -v Up-to'
