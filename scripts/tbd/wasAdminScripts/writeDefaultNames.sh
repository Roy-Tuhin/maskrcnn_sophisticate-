#!/bin/bash

fileName="defaultNames.txt"
echo `cat  $fileName | cut -f1 -d'('`>$fileName
echo `cat  $fileName | cut -f1 -d' '` ##serverName
echo `cat  $fileName | cut -f2 -d' '` ##cellName
echo `cat  $fileName | cut -f3 -d' '` ##NodeName

replaceServerName=`cat was.config.properties | grep standAloneManagedServer\=`
replaceCellName=`cat was.config.properties | grep cellName\=`
replaceNodeName=`cat was.config.properties | grep customNodeName\=`
echo $replaceServerName
echo $replaceCellName
echo $replaceNodeName

standAloneManagedServer="standAloneManagedServer=`cat  $fileName | cut -f1 -d' '`"
cellName="cellName=`cat  $fileName | cut -f2 -d' '`"
customNodeName="customNodeName=`cat  $fileName | cut -f3 -d' '`"

sed 's/'"$replaceServerName"'/'"$standAloneManagedServer"'/g' was.config.properties > was.config.properties1
sed 's/'"$replaceCellName"'/'"$cellName"'/g' was.config.properties1 > was.config.properties2
rm was.config.properties1
sed 's/'"$replaceNodeName"'/'"$customNodeName"'/g' was.config.properties2 > was.config.properties3
rm was.config.properties2
mv was.config.properties was.config.properties_bkup
mv was.config.properties3 was.config.properties

lines=`sed -n '$=' was.config.properties`
echo $lines

