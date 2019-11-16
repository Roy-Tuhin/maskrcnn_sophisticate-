#!/bin/bash

##----------------------------------------------------------
### CVS config
##----------------------------------------------------------
echo -n "Enter username > "
read username
if [ "$username" == "" ]; then
  echo "Exiting program."
  exit 1
fi

ipaddr="10.4.71.121"
port="2401"

echo "Default CVS Server IP > $ipaddr"
echo "Default CVS Server Port > $port"

LINE="export CVSROOT=\":pserver:$username@$ipaddr:$port/data/CVS_REPO\""
FILE=~/.bashrc
echo $LINE
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="alias cvstt='cvs status 2>/dev/null | grep ^File | grep -v Up-to'"
echo $LINE
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

source ~/.bashrc
cvs login
