#!/bin/bash

##----------------------------------------------------------
## Rasdaman
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Rasdaman is an Array DBMS, that is: a Database Management System which adds capabilities for storage and retrieval of massive multi-dimensional arrays, such as sensor, image, and statistics data.
#
## http://www.rasdaman.org/wiki/InstallFromDEB
#
##----------------------------------------------------------

# Import the rasdaman repository public key to the apt keychain:
wget -O - http://download.rasdaman.org/packages/rasdaman.gpg | sudo apt-key add -

# Add the rasdaman repository to apt.
## stable

# # For ubuntu 16.04
# echo "deb [arch=amd64] http://download.rasdaman.org/packages/deb xenial stable" \
#   | sudo tee /etc/apt/sources.list.d/rasdaman.list

# For ubuntu 18.04
echo "deb [arch=amd64] http://download.rasdaman.org/packages/deb bionic stable" \
  | sudo tee /etc/apt/sources.list.d/rasdaman.list

sudo apt update 
sudo -E apt -q -y install rasdaman
source /etc/profile.d/rasdaman.sh

# Update
# sudo apt-get update
# sudo apt-get install rasdaman
# sudo migrate_petascopedb.sh

# # Administration
# sudo service rasdaman start
# sudo service rasdaman stop
# sudo service rasdaman status


##----------------------------------------------------------
# Review the installation settings:
##----------------------------------------------------------

# Install path: /opt/rasdaman/
# User: rasdaman
# Database: sqlite, /opt/rasdaman/data/
# Install webapps: True
#   Petascopedb url: jdbc:postgresql://localhost:5432/petascopedb
#   Petascopedb user: petauser
#   Deployment: external
#   Webapps path: /var/lib/tomcat8/webapps
#   Webapps logs: /var/log/tomcat8
# Insert demos: True

# Rasdaman installed and configured successfully.
# Next steps
#  * Make sure that rasql is on the PATH first:
#    $ source /etc/profile.d/rasdaman.sh
#  * Then try some rasql queries using the rasql CLI, e.g:
#    $ rasql -q 'select encode( mr, "png" ) from mr' --out file
#  * Try the WCS client in your browser at http://localhost:8080/rasdaman/ows


# More information can be found at http://rasdaman.org. Have fun!
# To add rasdaman to the PATH: source /etc/profile.d/rasdaman.sh
# Processing triggers for libc-bin (2.27-3ubuntu1) ...
# Processing triggers for systemd (237-3ubuntu10.3) ...
# Processing triggers for ureadahead (0.100.0-20) ...

## https://www.revolvermaps.com/livestats/globe/a1850emr3y9/