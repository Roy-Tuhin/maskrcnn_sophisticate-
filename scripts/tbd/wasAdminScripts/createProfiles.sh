#!/bin/ksh

###### Script to create Deployment manager profile and a custom profile for Websphere Application Server 6.1
######  Reading the properties file 
# Fetching profileType property value from was.config.properties

profileType=`cat was.config.properties| grep profileType | grep -v "#" | cut -f2 -d'='`
if [ -z "$profileType" ]
then
  echo "Profile type to be created is blank"
  echo "Profile type to be created is blank" > Setup.log
  exit -1
else
  if [ $profileType = "D" -o $profileType = "C" -o $profileType = "B" -o $profileType = "A" ]
  then 
    echo "Profile Type : $profileType"
    echo "Profile Type : $profileType" >> log/Setup.log
  else
    echo "Invalid Profile type : $profileType"
    echo "Profile type valid choices are : [ D - Deployment Manager, C - Custom, B - Both , A - Application Server]"
    echo "Invalid Profile type : $profileType" >> log/Setup.log
    echo "Profile type valid choices are : [ D - Deployment Manager, C - Custom, B - Both , A - Application Server]" >> log/Setup.log
    exit -1 
  fi
fi

# Fetching wasNDVersion property from was.config.properties
wasNDVersion=`cat was.config.properties| grep wasNDVersion | grep -v "#" | cut -f2 -d'='`
if [ -z "$wasNDVersion" ]
then
  echo "Please set the flag mentioning if this is Network Deployment version of Websphere Application Server"
  echo "Please set the flag mentioning if this is Network Deployment version of Websphere Application Server" >> log/Setup.log
  exit -1
else
  if [ $wasNDVersion = "Y" ]
  then
    echo "WAS Network Deployment Version"
  elif [ $wasNDVersion = "N" ]
  then
    echo "Non - ND version of WAS, ONLY APPLICATION SERVER PROFILE WILL BE CREATED"
    profileType="A"
  else
    echo "Invalid choice for flag wasNDversion. Valid values [ Y - Yes, N - No ]"
    echo "Invalid choice for flag wasNDversion. Valid values [ Y - Yes, N - No ]" >> log/Setup.log
    exit -1
  fi
fi

# Fetching wasRoot property from was.config.properties
wasRoot=`cat was.config.properties| grep wasRoot | grep -v "#" | cut -f2 -d'='`
if [ -z "$wasRoot" ]
then
  echo "Websphere Application Server root directory is blank"
  echo "Websphere Application Server root directory is blank" >> log/Setup.log
  exit -1
else
  echo "WAS Installation directory : $wasRoot"
fi

# If WAS is ND Version then check the validity of profileType property value
if [ $wasNDVersion = "Y" ]
then
  if [ $profileType = "D" -o $profileType = "B" ]
  then
     managerProfileName=`cat was.config.properties| grep managerProfileName | grep -v "#" | cut -f2 -d'='`
     if [ -z "$managerProfileName" ]
     then
       echo "Manager profile cannot be blank for Network Deployment version of WAS"
       echo "Manager profile cannot be blank for Network Deployment version of WAS" >> log/Setup.log
       exit -1
     else
       echo "Manager profile name : $managerProfileName"
     fi
  elif [ $profileType = "A" ]
  then
     echo "Application Server profile cannot be created on ND version with this script"
     echo "Application Server profile cannot be created on ND version with this script" >> log/Setup.log
     exit -1
  else
     echo "Manager profile name not set"
     echo "Manager profile name not set" >> log/Setup.log
  fi
fi

if [ $profileType = "C" ]
then
  managerHost=`cat was.config.properties| grep managerHost | grep -v "#" | cut -f2 -d'='`
  if [ -z "$managerHost" ]
  then 
    echo "Manager Host cannot be blank for Custom profile creation"
    echo "Manager Host cannot be blank for Custom profile creation" >> log/Setup.log
    exit -1
  else
    echo "Deployment Manager Host : $managerHost"
  fi

  managerPort=`cat was.config.properties| grep managerPort | grep -v "#" | cut -f2 -d'='`
  if [ -z "$managerPort" ]
  then
    echo "Manager Port cannot be blank for Custom profile creation"
    echo "Manager Port cannot be blank for Custom profile creation" >> log/Setup.log
    exit -1
  else
    echo "Deployment Manager Port : $managerPort"
  fi
fi

customProfileName=`cat was.config.properties| grep customProfileName | grep -v "#" | cut -f2 -d'='`
if [ -z "$customProfileName" ]
then
  echo "Custom profile name is blank"
  echo "Custom profile name is blank" >> log/Setup.log
  exit -1
else
  echo "Custom profile name : $customProfileName"
fi

appName=`cat was.config.properties| grep appName | grep -v "#" | cut -f2 -d'='`
if [ -z "$appName" ]
then
  echo "Application name is blank"
  echo "Application name is blank" >> log/Setup.log
  exit -1
else
  echo "Application Name : $appName"
fi

enableSecurity=`cat was.config.properties| grep securityEnabled | grep -v "#" | cut -f2 -d'='`
if [ -z "$enableSecurity" ]
then
  echo "Security Enabled flag is blank"
  echo "Security Enabled flag is blank" >> log/Setup.log
  exit -1
else
  echo "Security Enabled flag : $enableSecurity"
fi

hostname=`hostname`

managerNodeName=Manager_$hostname
echo "Deployment Manager node name : $managerNodeName"

defaultNodeAndCell=`cat was.config.properties| grep defaultNodeAndCell | grep -v "#" | cut -f2 -d'='`
if [ -z "$defaultNodeAndCell" ]
then
  echo "defaultNodeAndCell is not specified, using defualt value for the flag [Y]"
  echo "defaultNodeAndCell is not specified, using defualt value for the flag [Y]">> log/Setup.log
  defaultNodeAndCell=Y
  #exit -1
else
  echo "Use default Node and Cell name : $defaultNodeAndCell"
  echo "Use default Node and Cell name : $defaultNodeAndCell" >> log/Setup.log
fi

if [ $defaultNodeAndCell = "N" -o $defaultNodeAndCell = "n" ]
then
	# Fetching cellName property from was.config.properties
	cellName=`cat was.config.properties| grep cellName | grep -v "#" | cut -f2 -d'='`
	if [ -z "$cellName" ]
	then
	  echo "Cell name is blank"
	  echo "Cell name is blank" >> log/Setup.log
	  exit -1
	else
	  echo "Cell name : $cellName"
	fi

	customNodeName=`cat was.config.properties| grep customNodeName | grep -v "#" | cut -f2 -d'='`
	if [ -z "$customNodeName" ]
	then
	  echo "No CustomNodeName specified, Using combination of customProfileName_hostname"
	  echo "No CustomNodeName specified, Using combination of customProfileName_hostname" >> log/Setup.log
	  customNodeName=$customProfileName"_"$hostname 
	  #exit -1
	else
	  echo "Custom Node name : $customNodeName"
	  echo "Custom Node name : $customNodeName" >> log/Setup.log
	fi
fi

adminUserName=`cat was.config.properties| grep adminUserName | grep -v "#" | cut -f2 -d'='`
if [ -z "$adminUserName" ]
then
  echo "No Admin User Name specified, using default as wasadmin"
  adminUserName="wasadmin"
else
  echo "Admin user name : $adminUserName"
  echo "Admin user name : $adminUserName" >> log/Setup.log
fi

adminPassword=`cat was.config.properties| grep adminPassword | grep -v "#" | cut -f2 -d'='`
if [ -z "$adminPassword" ]
then
  echo "No Admin password specified, using default as wasadmin"
  adminPassword="wasadmin"
else
  echo "Admin password : $adminPassword"
  echo "Admin password : $adminPassword" >> log/Setup.log
fi

if [ ! -d $wasRoot/profiles -o ! -w $wasRoot/profiles ]
then
  echo "profiles Directory doesn't Exists or is not writable"
  echo "Create profiles directory under $wasRoot"
  echo "profiles Directory doesn't Exists or is not writable" >> log/Setup.log
  echo "Create profiles directory under $wasRoot" >> log/Setup.log
t -1
else
  echo "Profiles Directory exist"

  if [ $wasNDVersion = "Y" ]
  then
    if [ ! -d $wasRoot/profiles/$managerProfileName ]
    then
      echo "Manager Profile directory doesn't exists"
      echo "Manager Profile directory doesn't exists" >> log/Setup.log
    elif [ $profileType = "D" -o $profileType = "B" ]
    then
      echo "Manager Profile directory already exists, Please provide any other name"
      echo "Manager Profile directory already exists, Please provide any other name" >> log/Setup.log
      exit -1
    fi

    if [ ! -d $wasRoot/profiles/$customProfileName ]
    then
      echo "Custom Profile directory doesn't exists"
      echo "Custom Profile directory doesn't exists" >> log/Setup.log
    elif [ $profileType = "C" -o $profileType = "B" ]
    then
      echo "Custom Profile directory already exists, Please provide any other name"
      echo "Custom Profile directory already exists, Please provide any other name" >> log/Setup.log
      exit -1
    fi

  elif [ $wasNDVersion = "N" ]
  then
    if [ ! -d $wasRoot/profiles/$customProfileName ]
    then
      echo "Application Server Profile directory doesn't exists"
      echo "Application Server Profile directory doesn't exists" >> log/Setup.log
    else
      echo "Application Server Profile directory already exists, Please provide any other name"
      echo "Application Server Profile directory already exists, Please provide any other name" >> log/Setup.log
      exit -1
    fi
  fi
fi

if [ ! -w $wasRoot/properties -o ! -w $wasRoot/logs ]
then
   echo "Either properties or logs folder is not writable in $wasRoot"
   echo "Either properties or logs folder is not writable in $wasRoot" >> log/Setup.log
fi

# Creating profiles

# Checking if WAS is ND or Non-ND version
# Creating Application server profile for Non-ND version 
# Creating Deployment manager/Custom/Both profiles for ND version
 
if [ $wasNDVersion = "N" -a $profileType = "A" ]
then
  echo "Creating Application Server Profile....."
  echo "Creating Application Server Profile....." >> log/Setup.log
  if [ $enableSecurity = "Y" -o $enableSecurity = "y" ]
  then
     if [ $defaultNodeAndCell = "Y" -o $defaultNodeAndCell = "y" ]
     then
        sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/default" -profileName $customProfileName -profilePath $wasRoot/profiles/$customProfileName
     else
        sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/default" -profileName $customProfileName -profilePath $wasRoot/profiles/$customProfileName -adminUserName $adminUserName -adminPassword $adminPassword -cellName $cellName -nodeName $customNodeName -hostName $hostname -enableAdminSecurity true
     fi
  else
     if [ $defaultNodeAndCell = "Y" -o $defaultNodeAndCell = "y" ]
     then
        sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/default" -profileName $customProfileName -profilePath $wasRoot/profiles/$customProfileName
     else
        sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/default" -profileName $customProfileName -profilePath $wasRoot/profiles/$customProfileName -adminUserName $adminUserName -adminPassword $adminPassword -cellName $cellName -nodeName $customNodeName -hostName $hostname -enableAdminSecurity false
     fi
  fi

  echo "Application Server profile created"
  echo "Application Server profile created" >> log/Setup.log

  serverSOAPPort=`cat $wasRoot/profiles/$customProfileName/logs/AboutThisProfile.txt | grep SOAP | cut -f2 -d':'`
  echo "The SOAP port for server is $serverSOAPPort"
  echo "The SOAP port for server is $serverSOAPPort" >> log/Setup.log

  AdminConsolePort=`cat $wasRoot/profiles/$customProfileName/logs/AboutThisProfile.txt | grep "Administrative console port" |cut -f2 -d':'`
  echo "You can access the Admin Console on port :$AdminConsolePort"
  echo "You can access the Admin Console on port :$AdminConsolePort" >> log/Setup.log

  echo "Starting the server created..." 
  echo "Starting the server created..." >> log/Setup.log
  sh $wasRoot/profiles/$customProfileName/bin/startServer.sh server1
  echo "Server started..."
  echo "Server started..." >> log/Setup.log

  #Writing defualt Names of the profiles
  if [ $defaultNodeAndCell = "Y" -o $defaultNodeAndCell = "y" ]
  then
  	>|defaultNames.txt
	sh $wasRoot/profiles/$customProfileName/bin/wsadmin.sh -lang jython -f getDefaultNames.py
	sh writeDefaultNames.sh
  fi

elif [ $wasNDVersion = "Y" ]
then
  if [ $profileType = "D" ]
  then
    echo "Creating Deployment Manager Profile..."
    echo "Creating Deployment Manager Profile..." >> log/Setup.log
    if [ $enableSecurity = "Y" -o $enableSecurity = "y" ]
    then
       sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/dmgr" -profileName $managerProfileName -profilePath $wasRoot/profiles/$managerProfileName -adminUserName $adminUserName -adminPassword $adminPassword -cellName $cellName -nodeName $managerNodeName -hostName $hostname -enableAdminSecurity true
    else
       sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/dmgr" -profileName $managerProfileName -profilePath $wasRoot/profiles/$managerProfileName -cellName $cellName -nodeName $managerNodeName -hostName $hostname -enableAdminSecurity false
    fi
 
    echo "Starting Deployment Manager..."
    echo "Starting Deployment Manager..." >> log/Setup.log
    sh $wasRoot/profiles/$managerProfileName/bin/startManager.sh
    echo "Deployment manager started..."
    echo "Deployment manager started..." >> log/Setup.log
    ManagerSOAPPort=`cat $wasRoot/profiles/$managerProfileName/logs/AboutThisProfile.txt | grep SOAP | cut -f2 -d':'`
    echo "Deployment Manager SOAP port is : $ManagerSOAPPort"
    echo "Deployment Manager SOAP port is : $ManagerSOAPPort" >> log/Setup.log
    AdminConsolePort=`cat $wasRoot/profiles/$managerProfileName/logs/AboutThisProfile.txt | grep "Administrative console port" | cut -f2 -d':'`
    echo "Deployment Manager profile created"
    echo "Deployment Manager profile created" >> log/Setup.log
    echo "You can access the Admin Console on port :$AdminConsolePort"  
    echo "You can access the Admin Console on port :$AdminConsolePort" >> log/Setup.log
  elif [ $profileType = "C" ]
  then
    echo "Creating Custom Profile..."
    echo "Creating Custom Profile..." >> log/Setup.log
    sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/managed" -profileName $customProfileName -profilePath $wasRoot/profiles/$customProfileName -nodeName $customNodeName -hostName $hostname
    echo "Federating node of custom profile to deployment manager ....."
    echo "Federating node of custom profile to deployment manager ....." >> log/Setup.log
    if [ $enableSecurity = "Y" -o $enableSecurity = "y" ]
    then
       sh $wasRoot/profiles/$customProfileName/bin/addNode.sh $managerHost $managerPort -username $adminUserName -password $adminPassword
    else
       sh $wasRoot/profiles/$customProfileName/bin/addNode.sh $managerHost $managerPort
    fi
  elif [ $profileType = "B" ]
  then
    echo "Creating Deployment Manager Profile..."
    echo "Creating Deployment Manager Profile..." >> log/Setup.log
    if [ $enableSecurity = "Y" -o $enableSecurity = "y" ]
    then
       sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/dmgr" -profileName $managerProfileName -profilePath $wasRoot/profiles/$managerProfileName -adminUserName $adminUserName -adminPassword $adminPassword -cellName $cellName -nodeName $managerNodeName -enableAdminSecurity true
    else
       sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/dmgr" -profileName $managerProfileName -profilePath $wasRoot/profiles/$managerProfileName -cellName $cellName -nodeName $managerNodeName -enableAdminSecurity false
    fi

    echo "Creating Custom Profile..."
    echo "Creating Custom Profile..." >> log/Setup.log
    sh $wasRoot/bin/manageprofiles.sh -create -templatePath "$wasRoot/profileTemplates/managed" -profileName $customProfileName -profilePath $wasRoot/profiles/$customProfileName -nodeName $customNodeName
    echo "Starting Deployment Manager..."
    echo "Starting Deployment Manager..." >> log/Setup.log
    sh $wasRoot/profiles/$managerProfileName/bin/startManager.sh
    echo "Deployment manager started...."
    echo "Deployment manager started...." >> log/Setup.log
    ManagerSOAPPort=`cat $wasRoot/profiles/$managerProfileName/logs/AboutThisProfile.txt | grep SOAP | cut -f2 -d':'`
    echo "Deployment Manager SOAP Port : $ManagerSOAPPort"
    echo "Deployment Manager SOAP Port : $ManagerSOAPPort" >> log/Setup.log
    echo "Federating node of custom profile to deployment manager ....."
    echo "Federating node of custom profile to deployment manager ....." >> log/Setup.log
    if [ $enableSecurity = "Y" -o $enableSecurity = "y" ]
    then
       sh $wasRoot/profiles/$customProfileName/bin/addNode.sh $hostname $ManagerSOAPPort -username $adminUserName -password $adminPassword
    else
       sh $wasRoot/profiles/$customProfileName/bin/addNode.sh $hostname $ManagerSOAPPort
    fi
    AdminConsolePort=`cat $wasRoot/profiles/$managerProfileName/logs/AboutThisProfile.txt | grep "Administrative console port" | cut -f2 -d':'`
    echo "You can access the Admin Console on port :$AdminConsolePort"
    echo "You can access the Admin Console on port :$AdminConsolePort" >> log/Setup.log
  fi
else
  echo "Invalid Option"
  echo "Invalid Option" >> log/Setup.log
fi
