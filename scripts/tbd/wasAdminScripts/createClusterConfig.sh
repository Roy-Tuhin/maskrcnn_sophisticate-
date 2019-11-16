#!/bin/ksh

wasRoot=`cat was.config.properties| grep wasRoot | cut -f2 -d'='`
if [ -z "$wasRoot" ]
then
  echo "Websphere Application Server root directory is blank"
  exit -1
else
  echo $wasRoot
fi

managerProfileName=`cat was.config.properties| grep managerProfileName | cut -f2 -d'='`
if [ -z "$managerProfileName" ]
then
  echo "Manager profile name is blank"
  exit -1
else
  echo $managerProfileName
fi

adminUserName=`cat was.config.properties| grep adminUserName | cut -f2 -d'='`
if [ -z "$adminUserName" ]
then
  echo "No Admin User Name specified, using default as wasadmin"
  adminUserName="wasadmin"
else
  echo $adminUserName
fi

adminPassword=`cat was.config.properties| grep adminPassword | cut -f2 -d'='`
if [ -z "$adminPassword" ]
then
  echo "No Admin password specified, using default as wasadmin"
  adminPassword="wasadmin"
else
  echo $adminPassword
fi

echo "Starting configuration for cluster"
sh $wasRoot/profiles/$customProfileName/bin/wsadmin.sh -lang jython -f getports.py
sh writeports.sh
sh $wasRoot/profiles/$managerProfileName/bin/wsadmin.sh -lang jython -f clusterServerCreation.py -conntype SOAP -user $adminUserName -password $adminPassword
echo "Cluster configuration done"
