#!/bin/bash

FILE=~/.bashrc
CMDDIR='cmd'

[[ -d $CMDDIR ]] || mkdir -p $CMDDIR

aptsearch="$CMDDIR/apt-search"
if [ ! -L $aptsearch ]; then
  echo "creating symlink: $aptsearch"
  ln -s $(pwd)/apt-search.sh $aptsearch
else
  echo "=>$aptsearch link exists"
fi


aptinstall="$CMDDIR/apt-install"
if [ ! -L $aptinstall ]; then
  echo "creating symlink: $aptinstall"
  ln -s $(pwd)/apt-install.sh $aptinstall
else
  echo "=>$aptinstall link exists"
fi



LINE="export LINUX_SCRIPTS_PATH='$(pwd)/cmd'"
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE='export PATH=$PATH:$LINUX_SCRIPTS_PATH'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

#alias brc="source $FILE"
#$brc
