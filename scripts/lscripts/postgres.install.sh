#!/bin/bash

##----------------------------------------------------------
### PostgresSQL
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
# http://www.gis-blog.com/how-to-install-postgis-2-3-on-ubuntu-16-04-lts/
# https://packages.ubuntu.com/xenial/postgresql-server-dev-9.5

# sudo -E apt -q -y install python-pip python-dev
sudo -E apt -q -y install libpq-dev postgresql postgresql-contrib pgadmin3
sudo -E apt -q -y install postgis
sudo -E apt -q -y install postgresql-server-dev-all
