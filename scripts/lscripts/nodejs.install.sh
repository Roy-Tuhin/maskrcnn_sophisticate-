#!/bin/bash


##----------------------------------------------------------
## Node Js an NPM
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## Issues:
##----------------------------------------------------------
# 1. deprecated warnings
#
# npm WARN deprecated gulp-util@3.0.8: gulp-util is deprecated - replace it, following the guidelines at https://medium.com/gulpjs/gulp-util-ca3b1f9f9ac5
# npm WARN deprecated graceful-fs@3.0.11: please upgrade to graceful-fs 4 for compatibility with current and future versions of Node.js
# npm WARN deprecated minimatch@2.0.10: Please update to minimatch 3.0.2 or higher to avoid a RegExp DoS issue
# npm WARN deprecated minimatch@0.2.14: Please update to minimatch 3.0.2 or higher to avoid a RegExp DoS issue
# npm WARN deprecated graceful-fs@1.2.3: please upgrade to graceful-fs 4 for compatibility with current and future versions of Node.js

# 2. In Ubuntu 18.04 LTS
# Package python-software-properties is not available, but is referred to by another package.
# This may mean that the package is missing, has been obsoleted, or
# is only available from another source
# However the following packages replace it:
#   software-properties-common

# E: Package 'python-software-properties' has no installation candidate
##----------------------------------------------------------


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

source $SCRIPTS_DIR/config.custom.sh

if [ -z "$NODEJS_VER" ]; then
  NODEJS_VER=9
  echo "Unable to get NODEJS_VER version, falling back to default version#: $NODEJS_VER"
fi

echo "LINUX_VERSION:$LINUX_VERSION"

## Ubuntu 16.04 LTS
if [[ $LINUX_VERSION == "16.04" ]]; then
  echo "...$LINUX_VERSION"
  sudo -E apt -q -y install python-software-properties
fi

## Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  echo $LINUX_VERSION
  sudo -E apt -q -y install software-properties-common
fi

## Kali 2019.1
if [[ $LINUX_ID == "Kali" ]]; then
  echo $LINUX_VERSION
  sudo -E apt -q -y install software-properties-common
fi

curl -sL https://deb.nodesource.com/setup_$NODEJS_VER.x | sudo -E bash -
sudo -E apt -q -y install nodejs
npm update -g npm
npm -v
node -v

mkdir "${CODEHUB_HOME}/.npm-packages"
touch ${CODEHUB_HOME}/.npmrc
echo prefix='${CODEHUB_HOME}/.npm-packages' > ${CODEHUB_HOME}/.npmrc

echo NPM_PACKAGES='$CODEHUB_HOME/.npm-packages' >> ${CODEHUB_ENV_FILE}
echo PATH='$NPM_PACKAGES/bin:$PATH' >> ${CODEHUB_ENV_FILE}
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
echo "export MANPATH='$NPM_PACKAGES/share/man:$(manpath)'" >> ${CODEHUB_ENV_FILE}

update_env_file

## cushion if source for bashrc does not happen
export MANPATH='$NPM_PACKAGES/share/man:$(manpath)'

## To install the Yarn package manager, run:

#curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
#sudo apt update && sudo apt install yarn

# source ${LINUX_SCRIPT_HOME}/nodejs.requirements.sh
