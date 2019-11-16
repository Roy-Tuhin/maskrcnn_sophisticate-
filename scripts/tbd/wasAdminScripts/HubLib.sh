#!/bin/bash

if [ -f HubLib.txt ]
then
   >|HubLib.txt
fi
# Change it to INSTALL_DIR path
currentPath=`pwd`
ls $currentPath/Hub/*.jar > HubLib.txt
