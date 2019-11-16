#!/bin/bash

#http://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
#http://stackoverflow.com/questions/84882/sudo-echo-something-etc-privilegedfile-doesnt-work-is-there-an-alterna

##grep -q -F "alias lt='ls -ltr'" ~/.bashrc || echo "alias lt='ls -ltr'" >> ~/.bashrc

source linuxscripts.config.sh

#FILE=$HOME/.bashrc
#LINE="alias lt='ls -ltr'"
#echo $LINE
#grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

#LINE='export LD_LIBRARY_PATH=/usr/local/lib'
#echo $LINE
#grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

#if [ -z $BASHRC_CUSTOM_ADDED ]; then
  FILE=$HOME/.bashrc
  LINE='source $HOME/'$LINUX_SCRIPT_BASE'/.bashrc-custom'
  echo $LINE
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  #FILE="linuxscripts.config.sh"
  #LINE='BASHRC_CUSTOM_ADDED=1'
  #echo $LINE
  #grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
#fi
