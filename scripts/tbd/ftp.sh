#!/bin/bash
HOST='172.19.144.150' # change the ipaddress accordingly
USER='msblr' # username also change
PASSWD='msblr@tcs' # password also change
#UDIRX=`pwd`

ftp -n -v $HOST << EOT
ascii
user $USER $PASSWD
prompt
cd MorganStanley
put testing1.x
bye
EOT
sleep 12
