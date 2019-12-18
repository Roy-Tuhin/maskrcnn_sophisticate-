#!/bin/bash

source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/aimldl.export.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/ps1.sh

## commands
alias lt='ls -lrth'
alias l='ls -lrth'

## change directory
alias aiml="cd ${AI_HOME}"
alias aidata="cd ${AI_DATA}"
alias ailogs="cd ${AI_LOGS}"
alias aidoc="cd ${AI_DOC}"
alias aicfg="cd ${AI_CFG}"
alias airpt="cd ${AI_REPORTS}"
alias aikb="cd ${AI_KBANK}"
alias aimnt="cd ${AI_MNT}"
alias aiweights="cd ${AI_WEIGHTS_PATH}"
alias aiapps="cd ${AI_APP}"
alias aiweb="cd ${AI_WEB_APP}"
alias aiscrpt="cd ${AI_HOME}/scripts"
