#!/bin/ksh

###### Script to delete profile for Websphere Application Server 6.1
######  Reading the properties file 

# Fetching wasRoot property from was.config.properties
wasRoot=`cat was.config.properties| grep wasRoot | grep -v "#" | cut -f2 -d'='`
if [ -z "$wasRoot" ]
then
  echo "Websphere Application Server root directory is blank"
  echo "Websphere Application Server root directory is blank" >> log/Delete.log
  exit -1
else
  echo "WAS Installation directory : $wasRoot"
fi

hostname=`hostname`

echo "Enter the profile name to be deleted : "
 read customProfileName
 
if [ -z $customProfileName ]
then
   echo "Profile name to be deleted cannot be left blank....exiting!"
   exit -1
fi	

if [ ! -d $wasRoot/profiles/$customProfileName ]
then
   echo "$customProfileName folder does not exists in $wasRoot/profiles/"
   echo "$customProfileName folder does not exists in $wasRoot/profiles/">> log/Delete.log
   exit -1
fi

if [ ! -w $wasRoot/profiles -o ! -w $wasRoot/profiles/$customProfileName ]
then
   echo "Either profiles or profiles/$customProfileName folder is not writable in $wasRoot"
   echo "Either profiles or profiles/$customProfileName folder is not writable in $wasRoot" >> log/Delete.log
   exit -1
fi
# Deleting profiles
  echo "Deleting Application Server Profile...$customProfileName"
  echo "Deleting Application Server Profile...$customProfileName" >> log/Delete.log
#  if [ ]
#  then
     sh $wasRoot/bin/manageprofiles.sh -delete -profileName $customProfileName
     sh $wasRoot/bin/manageprofiles.sh -validateAndUpdateRegistry
#  fi
#  echo "Application Server profile $customProfileName deleted"
#  echo "Application Server profile $customProfileName deleted" >> log/Delete.log
