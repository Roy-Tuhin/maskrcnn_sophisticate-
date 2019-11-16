#!/bin/ksh
wasRoot=`cat was.config.properties| grep wasRoot | grep -v "#" | cut -f2 -d'='`
if [ -z "$wasRoot" ]
then
  echo "Websphere Application Server root directory is blank"
  exit -1
else
  echo $wasRoot
fi

appDepMode=`cat was.config.properties| grep appDepMode | grep -v "#" | cut -f2 -d'='`
if [ -z "$appDepMode" ]
then
  echo "appDepMode can't be blank"
  exit -1
else
  if [ $appDepMode = "s" -o $appDepMode = "C" -o $appDepMode = "s" -o $appDepMode = "S" ]
  then
    echo "appDepMode is :$appDepMode"
  else
    echo :"appDepMode is not valid. Valid values are s,S,c or C"  
    exit -1 
  fi
fi

customProfileName=`cat was.config.properties| grep customProfileName | grep -v "#" | cut -f2 -d'='`
if [ $appDepMode = "s" -o $appDepMode = "S" ]
then 
  if [ -z "$customProfileName" ]
  then
    echo "Custom profile name is blank"
    exit -1
  else
  echo $customProfileName
  fi
fi

managerProfileName=`cat was.config.properties| grep managerProfileName | grep -v "#" | cut -f2 -d'='`
if [ $appDepMode = "c" -o $appDepMode = "C" ]
then
  if [ -z "$managerProfileName" ]
  then
    echo "Manager profile name is blank"
    exit -1
  else
  echo $managerProfileName
  fi
fi

appHome=`cat was.config.properties| grep "appHome[ ]*=" | grep -v "#" | cut -f2 -d'='`
if [ -z "$appHome" ]
then
  echo "EAI Home is blank. Exiting"
  exit -1
fi

logDir=`cat was.config.properties| grep logDir | grep -v "#" | cut -f2 -d'='`
if [ -z "$logDir" ]
then
  echo "Log Directory path is blank. So using $appHome/properties/Deployment/logs as default."
  logDir=$appHome/properties/Deployment/logs
  echo $logDir
elif [ ! -w $logDir ]
then
  echo "Log Directory path doesn't exist or is not writable."
else
  echo "Log directory path is $logDir"
fi

adminUserName=`cat was.config.properties| grep adminUserName | cut -f2 -d'='`
if [ -z "$adminUserName" ]
then
   adminUserName=`cat was.config.properties| grep adminUserName | grep -v "#" | cut -f2 -d'='`
   if [ -z "$adminUserName" ]
   then
      echo "No Admin User Name specified, using default as wasadmin"
      adminUserName="wasadmin"
   else
      echo $adminUserName
   fi
fi

adminPassword=`cat was.config.properties| grep adminPassword | cut -f2 -d'='`
if [ -z "$adminPassword" ]
then
   adminPassword=`cat was.config.properties| grep adminPassword | grep -v "#" | cut -f2 -d'='`
   if [ -z "$adminPassword" ]
   then
      echo "No Admin password specified, using default as wasadmin"
      adminPassword="wasadmin"
   else
      echo $adminPassword
   fi
fi

hostname=`hostname`
echo "Starting deployment synchronization..."
if [ $appDepMode = "s" -o $appDepMode = "S" ]
then
   sh $wasRoot/profiles/$customProfileName/bin/wsadmin.sh -lang jython -f syncDeployment.py $hostname $logDir -conntype SOAP -user $adminUserName -password $adminPassword
else
   sh $wasRoot/profiles/$managerProfileName/bin/wsadmin.sh -lang jython -f syncDeployment.py $hostname $logDir -conntype SOAP -user $adminUserName -password $adminPassword
fi

