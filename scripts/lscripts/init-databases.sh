#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

#----------------------------------------------------------
# Databases
#----------------------------------------------------------

# MySQL
source $LSCRIPTS/mysql.install.sh  ## apt-get
# PostgreSQL
source $LSCRIPTS/postgres.install.sh  ## apt-get
# rasdaman
source $LSCRIPTS/rasdaman.db.install.sh
# redis
source $LSCRIPTS/redis.install.sh   ## wget
