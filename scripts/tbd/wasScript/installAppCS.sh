#!/bin/bash
profilePath="/home/was6/profiles/HUBDev"
scriptHome="$profilePath/wasScript"
standAloneServerName="server1"

echo "Enter Application Archive Path: "
read appHome
echo "Enter Archive File Name: "
read archiveFileName
echo "Enter Application Name: "
read appName
#echo "Enter Node Name: "
#read standAloneNodeName
#echo "Enter Cell Name: "
#read cellName



sed -i 's/appHome\=\".*\"/appHome\=\"'$appHome'\"/g' $scriptHome/installAppCS.py
sed -i 's/archiveFileName\=\".*\"/archiveFileName\=\"'$archiveFileName'\"/g' $scriptHome/installAppCS.py
sed -i 's/appName\=\".*\"/appName\=\"'$appName'\"/g' $scriptHome/installAppCS.py
#sed -i 's/standAloneNodeName\=\".*\"/standAloneNodeName\=\"'$standAloneNodeName'\"/g' $scriptHome/installAppCS.py
#sed -i 's/cellName\=\".*\"/cellName\=\"'$cellName'\"/g' $scriptHome/installAppCS.py
$profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/installAppCS.py
