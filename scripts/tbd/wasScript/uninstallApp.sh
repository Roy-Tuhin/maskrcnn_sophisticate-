#!/bin/bash
profilePath="/home/was6/profiles/HUBDev"
scriptHome="$profilePath/wasScript"

echo "Enter Application Name to be uninstalled: "
read appName

sed -i 's/appName\=\".*\"/appName\=\"'$appName'\"/g' $scriptHome/uninstallApp.py
$profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/uninstallApp.py
