#!/bin/ksh
wasRoot=`cat was.config.properties| grep wasRoot | grep -v "#" | cut -f2 -d'='`
if [ -z "$wasRoot" ]
then
  echo "Websphere Application Server root directory is blank."
  exit -1
else
  echo "Websphere Root is $wasRoot"
fi

# Fetching wasNDVersion property from was.config.properties
wasNDVersion=`cat was.config.properties| grep wasNDVersion | grep -v "#" | cut -f2 -d'='`
if [ -z "$wasNDVersion" ]
then
  echo "Please set the flag mentioning if this is Network Deployment version of Websphere Application Server"
  exit -1
else
  if [ $wasNDVersion = "Y" -o $wasNDVersion = "y" ]
  then
    echo "WAS Network Deployment Version"
  elif [ $wasNDVersion = "N" -o $wasNDVersion = "n" ]
  then
    echo "Non - ND version of WAS"
  else
    echo "Invalid choice for flag wasNDversion. Valid values [ Y - Yes, N - No ]"
    exit -1
  fi
fi

appHome=`cat was.config.properties| grep appHome | grep -v "#" | cut -f2 -d'='`
if [ -z "$appHome" ]
then
  echo "Websphere Application Server root directory is blank."
elif [ ! -w $appHome ]
then
    echo "$appHome doesn't exist or is not writable" 
else
  echo "appHome is $appHome"
fi

logDir=`cat was.config.properties| grep logDir | grep -v "#" | cut -f2 -d'='`
if [ -z "$logDir" ]
then
  echo "Log Directory path is blank. So using $appHome/properties/Deployment/logs as default."
  logDir=$appHome/properties/Deployment/logs
  echo $logDir
elif [ ! -w $logDir ]
then
  echo "Log Directory path doesn't exist or is not writable"
else
  echo "Log directory path is $logDir"
fi

if [ ! -d $logDir ]
then
   mkdir $logDir
fi
appName=`cat was.config.properties| grep appName | grep -v "#" | cut -f2 -d'='`
if [ -z "$appName" ]
then
  echo "appName is blank"
  exit -1
else
  echo "Application Name is  $appName"
fi

appDepMode=`cat was.config.properties| grep appDepMode | grep -v "#" | cut -f2 -d'='`
if [ -z "$appDepMode" ]
then
  echo "Application Deployment mode is blank."
  exit -1
elif [ $appDepMode = "S" -o $appDepMode = "C" -o $appDepMode = "s" -o $appDepMode = "c" ]
then
  echo "Application deploy mode is $appDepMode"
else
  echo "Invalid application deployment mode."
  exit -1
fi

profileName=""

if [ $appDepMode = "S" -o $appDepMode = "s" ]
then
   standAloneServerName=`cat was.config.properties| grep standAloneManagedServer= | grep -v "#" | cut -f2 -d'='`
   if [ -z "$standAloneServerName" ]
   then
      echo "standAloneServerName is blank."
      exit -1
   fi

   customProfileName=`cat was.config.properties| grep customProfileName | grep -v "#" | cut -f2 -d'='`
   if [ -z "$customProfileName" ]
   then
     echo "Custom profile name is blank"
     exit -1
   else
     echo "Custom profile name is $customProfileName."
     profileName=$customProfileName
   fi
fi

if [ $appDepMode = "C" -o $appDepMode = "c" ]
then
   echo "Working .... "
   ClusterName=`cat was.config.properties| grep ClusterName | grep -v "#" | cut -f2 -d'='`
   if [ -z "$ClusterName" ]
   then
      echo "ClusterName is blank"
      exit -1
   fi

   managerProfileName=`cat was.config.properties| grep managerProfileName | grep -v "#" | cut -f2 -d'='`
   if [ -z "$managerProfileName" ]
   then
     echo "Manager profile name is blank"
     exit -1
   else
     echo "Manager profile name is $managerProfileName"
     profileName=$managerProfileName
   fi
fi

adminUserName=$WAS_ADMIN_USER
if [ -z "$adminUserName" ]
then
   adminUserName=`cat was.config.properties| grep adminUserName | grep -v "#" | cut -f2 -d'='`
   if [ -z "$adminUserName" ]
   then
      echo "No Admin User Name specified, using default as wasadmin"
      adminUserName="wasadmin"
   else
      echo "Admin user name : $adminUserName"
   fi
fi

adminPassword=$WAS_ADMIN_PASSWD
if [ -z "$adminPassword" ]
then
   adminPassword=`cat was.config.properties| grep adminPassword | grep -v "#" | cut -f2 -d'='`
   if [ -z "$adminPassword" ]
   then
     echo "No Admin password specified, using default as wasadmin"
     adminPassword="wasadmin"
   else
     echo "Admin password : $adminPassword"
   fi
fi

echo "Building EAR file..."
sh $wasRoot/profiles/$profileName/bin/ws_ant.sh -f HUB.xml  -DlogDir=$logDir
returnCode=$?

