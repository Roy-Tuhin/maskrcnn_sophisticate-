#!/bin/bash
##----------------------------------------------------------
## scalabel
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://www.scalabel.ai/
## https://www.youtube.com/watch?v=4tFYlzPIDy4&feature=youtu.be
#
## https://github.com/ucbdrive/scalabel
## https://github.com/ucbdrive/bdd-data
## https://bdd-data.berkeley.edu/
#
## Install golang, nodejs and npm.
#
##----------------------------------------------------------

source ./lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

source ./numthreads.sh ##NUMTHREADS
DIR="scalabel"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/ucbdrive/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

## get go dependencies
go get github.com/aws/aws-sdk-go
go get github.com/mitchellh/mapstructure
go get gopkg.in/yaml.v2
go get github.com/satori/go.uuid

## Compile
# go build -i -o ./bin/scalabel ./server/http
go build -i -o $PROG_DIR/bin/scalabel $PROG_DIR/server/http

## Install
npm install
## If you are debugging the code, it is helpful to build the javascript code in development mode, in which you can trace the javascript source code in your browser debugger.

# node_modules/.bin/npx webpack --config webpack.config.js --mode=production
# node_modules/.bin/npx webpack --config webpack.config.js --mode=development
$PROG_DIR/node_modules/.bin/npx webpack --config $PROG_DIR/webpack.config.js --mode=development

## Prepare data directory
mkdir $PROG_DIR/data
# cp app/config/default_config.yml data/config.yml
cp $PROG_DIR/app/config/default_config.yml $PROG_DIR/data/config.yml

## Launch the server
## server can be accessed at:
## http://localhost:8686
#
# ./bin/scalabel --config ./data/config.yml
$PROG_DIR/bin/scalabel --config $PROG_DIR/data/config.yml

## Install BDD toolkit and Get labels
##  bdd data toolkit: https://github.com/ucbdrive/bdd-data
source $LSCRIPTS/bdd-data.ai.tool.install.sh

cd $LINUX_SCRIPT_HOME
