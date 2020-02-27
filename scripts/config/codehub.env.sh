#!/bin/bash

## TODO: Instead of echo to .bashrc, echo it in this file

source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/codehub.export.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/ps1.sh

## commands
alias lt='ls -lrth'
alias l='ls -lrth'
alias gccselect='source ${LINUX_SCRIPT_HOME}/utils/gcc-select.sh'
alias bazelselect='source ${LINUX_SCRIPT_HOME}/utils/bazel-select.sh'
alias getip='source ${LINUX_SCRIPT_HOME}/utils/ip.sh'
alias pykill="bash ${AI_HOME}/scripts/utils/pykill.sh"

## change directory
alias lscripts="cd ${LINUX_SCRIPT_HOME}"
alias dscripts="cd ${CHUB_HOME}/scripts/docker"
alias chub="cd ${CHUB_HOME}"

alias technotes='cd ${CHUB_HOME}/technotes'

alias chubdata="cd ${CHUB_DATA}"
alias chublogs="cd ${CHUB_LOGS}"
alias chubtml="cd ${CHUB_TMP}"

## util scripts
alias androidstudio="bash ${CHUB_HOME}/tools/android-studio/bin/studio.sh"

# ### CVS
alias cvstt='cvs status 2>/dev/null | grep ^File | grep -v Up-to'

# NPM_PACKAGES=/codehub/.npm-packages
# PATH=/home/baaz/.npm-packages/bin:/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/lib/jvm/java-8-openjdk-amd64/bin:/codehub/android/sdk/tools:/codehub/android/sdk/platform-tools:/home/baaz/softwares/blender:/home/baaz/softwares/meshlab/src/distrib
# export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# NPM_PACKAGES=/codehub/.npm-packages
# PATH=/codehub/.npm-packages/bin:/home/baaz/.npm-packages/bin:/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/lib/jvm/java-8-openjdk-amd64/bin:/codehub/android/sdk/tools:/codehub/android/sdk/platform-tools:/home/baaz/softwares/blender:/home/baaz/softwares/meshlab/src/distrib
# export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
