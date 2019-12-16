#!/bin/bash

## Inspired by:
## https://github.com/ApolloAuto/apollo/blob/master/scripts/apollo_base.sh


ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"
# echo $ROOT_DIR

setup_environment() {
  local FILE=$HOME/.bashrc
  local LINE="source $ROOT_DIR/scripts/config/aimldl.env.sh"
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}

setup_environment

source $HOME/.bashrc

mkdir -p $HOME/public_html
ln -s $ROOT_DIR $HOME/public_html/aimldl


## setup the external directory
# source $ROOT_DIR/scripts/setup.external.sh
