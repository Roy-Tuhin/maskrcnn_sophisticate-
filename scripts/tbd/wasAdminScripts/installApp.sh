#!/bin/bash
scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
adminScripts="$scriptHome/wasAdminScripts"
	wasRoot=`cat $scriptHome/wasAdminScripts/was.config.properties| grep wasRoot | grep -v "#" | cut -f2 -d'='`
	if [ -z "$wasRoot" ]
	then
	  echo "Websphere Application Server root directory is blank."
	  exit -1
	else
	  echo "Websphere Root is $wasRoot"
	fi

	# Fetching wasNDVersion property from $scriptHome/wasAdminScripts/was.config.properties
	wasNDVersion=`cat $scriptHome/wasAdminScripts/was.config.properties| grep wasNDVersion | grep -v "#" | cut -f2 -d'='`
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

	appHome=`cat $scriptHome/wasAdminScripts/was.config.properties| grep appHome | grep -v "#" | cut -f2 -d'='`
	if [ -z "$appHome" ]
	then
	  echo "Application Home directory is blank."
	elif [ ! -w $appHome ]
	then
	    echo "$appHome doesn't exist or is not writable" 
	else
	  echo "appHome is $appHome"
	fi

	appName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep appName | grep -v "#" | cut -f2 -d'='`
	if [ -z "$appName" ]
	then
	  echo "appName is blank"
	  exit -1
	else
	  echo "Application Name is  $appName"
	fi

        logDir=`cat $scriptHome/wasAdminScripts/was.config.properties| grep logDir | grep -v "#" | cut -f2 -d'='`
        if [ -z "$logDir" ]
        then
          echo "Log Directory path is blank. So using $installDir/logs/HUB as default."
          case $appName in
	          BancsEAR)
                          logDir="$installDir/logs/HUB"
                          ;;
                  *)      echo "Invalid Application...please ask your System Administrator to support installation of NEW Application"
                          exit 1
                          ;;
          esac
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

	archiveFileName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep archiveFileName | grep -v "#" | cut -f2 -d'='`
	if [ -z "$archiveFileName" ]
	then
	  echo "Archive File Name is blank"
	  exit -1
	else
	  echo "Archive File Name is  $archiveFileName"
	fi

	appDepMode=`cat $scriptHome/wasAdminScripts/was.config.properties| grep appDepMode | grep -v "#" | cut -f2 -d'='`
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
	   standAloneServerName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep standAloneManagedServer= | grep -v "#" | cut -f2 -d'='`
	   if [ -z "$standAloneServerName" ]
	   then
	      echo "standAloneServerName is blank."
	      exit -1
	   fi

	customProfileName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep customProfileName | grep -v "#" | cut -f2 -d'='`
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
	   ClusterName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep ClusterName | grep -v "#" | cut -f2 -d'='`
	   if [ -z "$ClusterName" ]
	   then
	      echo "ClusterName is blank"
	      exit -1
	   fi

	   managerProfileName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep managerProfileName | grep -v "#" | cut -f2 -d'='`
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
	   adminUserName=`cat $scriptHome/wasAdminScripts/was.config.properties| grep adminUserName | grep -v "#" | cut -f2 -d'='`
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
	   adminPassword=`cat $scriptHome/wasAdminScripts/was.config.properties| grep adminPassword | grep -v "#" | cut -f2 -d'='`
	if [ -z "$adminPassword" ]
	then
	     echo "No Admin password specified, using default as wasadmin"
	     adminPassword="wasadmin"
	else
	     echo "Admin password : $adminPassword"
	fi

    hostname=`hostname`
   # currentDir=`pwd`
    cd $scriptHome/wasAdminScripts
    sh $wasRoot/profiles/$profileName/bin/wsadmin.sh -f installApp.py $hostname -conntype SOAP -user $adminUserName -password $adminPassword

  returnCode=$?
  if [ $returnCode -eq 0 ]
  then
     if [ $wasNDVersion = "N" -o $wasNDVersion = "n" ]
     then
         sh $wasRoot/profiles/$profileName/bin/stopServer.sh $standAloneServerName -username $adminUserName -password $adminPassword
         sh $wasRoot/profiles/$profileName/bin/startServer.sh $standAloneServerName -username $adminUserName -password $adminPassword
     else
         sh $scriptHome/wasAdminScripts/syncDeployment.sh
     fi
  fi
  #cd $currentDir
fi
