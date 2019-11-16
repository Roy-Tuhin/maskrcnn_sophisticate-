#!/bin/bash

scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
adminScripts="$scriptHome/wasAdminScripts"

fileName="$scriptHome/defaultNames.txt"
echo `cat  $fileName | cut -f1 -d'('`>$fileName
echo `cat  $fileName | cut -f1 -d' '` ##serverName
echo `cat  $fileName | cut -f2 -d' '` ##cellName
echo `cat  $fileName | cut -f3 -d' '` ##NodeName

replaceServerName=`cat $scriptHome/wasAdminScripts/was.config.properties | grep standAloneManagedServer\=`
replaceCellName=`cat $scriptHome/wasAdminScripts/was.config.properties | grep cellName\=`
replaceNodeName=`cat $scriptHome/wasAdminScripts/was.config.properties | grep customNodeName\=`
echo $replaceServerName
echo $replaceCellName
echo $replaceNodeName

standAloneManagedServer="standAloneManagedServer=`cat  $fileName | cut -f1 -d' '`"
cellName="cellName=`cat  $fileName | cut -f2 -d' '`"
customNodeName="customNodeName=`cat  $fileName | cut -f3 -d' '`"

sed 's/'"$replaceServerName"'/'"$standAloneManagedServer"'/g' $scriptHome/wasAdminScripts/was.config.properties > $scriptHome/wasAdminScripts/was.config.properties1
sed 's/'"$replaceCellName"'/'"$cellName"'/g' $scriptHome/wasAdminScripts/was.config.properties1 > $scriptHome/wasAdminScripts/was.config.properties2
rm $scriptHome/wasAdminScripts/was.config.properties1
sed 's/'"$replaceNodeName"'/'"$customNodeName"'/g' $scriptHome/wasAdminScripts/was.config.properties2 > $scriptHome/wasAdminScripts/was.config.properties3
rm $scriptHome/wasAdminScripts/was.config.properties2
mv $scriptHome/wasAdminScripts/was.config.properties $scriptHome/wasAdminScripts/was.config.properties_bkup
mv $scriptHome/wasAdminScripts/was.config.properties3 $scriptHome/wasAdminScripts/was.config.properties

lines=`sed -n '$=' $scriptHome/wasAdminScripts/was.config.properties`
echo $lines

