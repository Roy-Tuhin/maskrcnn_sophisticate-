#!/bin/bash

scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
adminScripts="$scriptHome/wasAdminScripts"

#Read Port numbers and port Name from $scriptHome/wasAdminScripts/portInfo.txt and write to WASPorts.txt file
declare -a varPorts 
declare -a varPortName 
declare -a portNameVar

customNodeName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep customNodeName | grep -v "#" | cut -f2 -d'='`
echo $customNodeName
if [ -z "$customNodeName" ]
then
  echo "No CustomNodeName specified, Using combination of customProfileName_hostname"
  echo "No CustomNodeName specified, Using combination of customProfileName_hostname" >> Setup.log
  exit -1
fi

varPorts=(`cat $scriptHome/wasAdminScripts/portInfo.txt | grep $customNodeName | cut -f3 -d' '`)
varPortName=(`cat $scriptHome/wasAdminScripts/portInfo.txt | grep $customNodeName | cut -f2 -d' '`)  
portNameVar=( bootstrapPortList soapPortList sasSSLlistenPortList csivSSLSrvrListenPortList csivSSLMultListenPortList adminHostList defaultHostList unicastPortList adminHostSSLList defaultHostSSLList sipDefaultHostList sipDefaultHostSecureList sipEndPointPortList sipEndPointPortSecureList sipMQPortList sipMQportSecureList orbListenPortList)
echo ${varPorts[@]}
echo ${varPortName[@]}
echo ${portNameVar[@]}
#echo ${portNameVar[@]}
fileName="$scriptHome/wasAdminScripts/was.config.properties"
if [ -f $fileName -o -s $fileName ]
then
  echo "$fileName exists...it will be overwritten!"
  >|$fileName
fi

for (( i = 0; i <  ${#varPorts[*]}; i++ ))
do
        echo "## ${varPortName[i]}"
        echo ${portNameVar[i]}=${varPorts[i]}
	echo "## ${varPortName[i]}">>$scriptHome/wasAdminScripts/was.config.properties
	echo ${portNameVar[i]}=${varPorts[i]}>>$scriptHome/wasAdminScripts/was.config.properties
done

for (( i = 1; i <= 9; i++ )) ### Outer for loop ###
do
   for (( j = 1 ; j <= 9; j++ )) ### Inner for loop ###
   do
        tot=`expr $i + $j`
        tmp=`expr $tot % 2`
        if [ $tmp -eq 0 ]; then
            echo -e -n "\033[47m "
        else
            echo -e -n "\033[40m "
        fi
  done
 echo -e -n "\033[40m" #### set back background colour to black
 echo "" #### print the new line ###
done

echo "# $scriptHome/wasAdminScripts/was.config.properties contains port details"
