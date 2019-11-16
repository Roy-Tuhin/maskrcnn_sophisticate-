#IMPORT STATEMENTS
import sys
import re
#from /home/was6/BhaskarM/WASAdmin/localScripts/wasAdminScripts 
import loggingjy 
from os  import environ
from java.lang import System
from java.lang import Integer
from java.lang import Exception
from java.util import Properties
from java.io import FileInputStream
from java.io import File
from java.util import Enumeration
from java.util import StringTokenizer
from java.util import ArrayList
from java.util import HashMap
from javax.management import *
import javax.management.Attribute


########################################
# INITIALIZING STRING VARIABLES .....  #
########################################
wasRoot=""
appHome=""
appName=""
archiveFileName=""
cellName=""
standAloneNodeName=""
standAloneServerName=""
clusterName=""
appDepMode=""
customProfileName=""
hostname=sys.argv[0]

#--------------------------------------------------------------
# Initializing Logger
#--------------------------------------------------------------

loggingjy.basicConfig(level=loggingjy.DEBUG, format='%(asctime)s %(levelname)-8s %(message)s', datefmt='%a, %d %b %Y %H:%M:%S', filename='log/install.log', filemode='a')

loggingjy.info("Starting the InstallApp script ...")

#---------------------------------------------------------------------
#  Method for print error message on console and in log file
#---------------------------------------------------------------------
def printErrorMessage(logMessage, exceptionObj):
    print "Error occurred. Check install.log in the log directory for more detials."
    loggingjy.error(logMessage)    
    loggingjy.error(exceptionObj.getMessage())
#--------------------------------------------------------------
# Property Validation Method
#--------------------------------------------------------------

def validateInput():
  valid="true"
  
  if(wasRoot==""):
      loggingjy.error("wasRoot can't be blank")
      valid="false"
	
  if(appName == ""):
    loggingjy.error("appName cannot be blank..")
    valid="false" 

  if(archiveFileName == ""):
    loggingjy.error("Archive File Name cannot be blank..")
    valid="false"
 
  if(appDepMode == ""):
       loggingjy.error("appDepMode can't be blank")
       valid="false"
  else:
       if(appDepMode == "C" or appDepMode =="c" or appDepMode =="S" or appDepMode =="s"):
            loggingjy.info("appDepMode is "+appDepMode)
       else:
            loggingjy.error("appDepMode is not valid. Entered value is: "+appDepMode)
            valid="false"
 
  if(cellName == ""):
    loggingjy.error("cellName can't be blank.")
    valid="false"

  if((appDepMode =='s' or appDepMode=='S') and standAloneNodeName == ""):
    loggingjy.error("Custom Node Name is blank, so, using combination of customProfileName_ hostName. Make sure that the custom profile's node was created using this combination.")
    if(customProfileName == ""):
      loggingjy.error("Custom Profile Name can't be blank if customNodeName is not specified.")
      valid="false"
     
  if(appHome  == ""):
    loggingjy.error("appHome can't be blank.")
    valid="false"
  else:
    if File(appHome).canWrite()!=1:
      loggingjy.error(" : " + appHome + " doesn't exist or is not writable")
      valid="false"

  if((appDepMode =="s" or appDepMode == "S") and (standAloneServerName=="")):
      loggingjy.error("standAloneManagedServer can't be blank")
      valid="false"
 
  if((appDepMode =="c" or appDepMode == "C")and (clusterName=="")):
      loggingjy.error("clusterName can't be blank")
      valid="false"

  if(valid=="false"):
    print "Error : Input Validation Failed Check install.log for more detials"
    print "Exiting...."
    System.exit(1) 
	
	
########################################################
#						       #	
# LOADING properties from was.config.properties file...#
#  	  					       #	
########################################################

myProps = Properties()
try:
    myProps.load(FileInputStream(File('was.config.properties')))
    propertyNames = myProps.propertyNames()
except Exception, e:
    printErrorMessage("Exception occurred while loading properties file['was.config.properties']...", e)
    System.exit(1)       

#####################################################
#						    #	
#   STORING PROPERTY VALUES IN VARIABLES....        #
#						    #	
#####################################################
try:
    while propertyNames.hasMoreElements():
      keyname = str(propertyNames.nextElement())
      value = myProps.getProperty(keyname)
    
      if keyname == "wasRoot":
      	wasRoot=value
    
      if keyname == "appName":
      	appName=value
   
      if keyname == "archiveFileName":
        archiveFileName=value

      if keyname == "appHome":
      	appHome=value
      	
      if keyname == "cellName":
        cellName=value

      if keyname == "customProfileName":
      	customProfileName=value
      	
      if keyname == "customNodeName":
        standAloneNodeName=value

      if keyname == "standAloneManagedServer":
      	standAloneServerName=value

      if keyname == "ClusterName":
        clusterName=value
      
      if keyname == "appDepMode":
        appDepMode=value

      	
except Exception, e:
    printErrorMessage("Exception occurred while storing properties into variables...", e)    
    System.exit(1)       

validateInput()

try:
    if (appDepMode =="s" or appDepMode =="S"):
        if(standAloneNodeName == ""):
            standAloneNodeName=customProfileName+"_"+hostname
        AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -installed.ear.destination "+appHome+"/data -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -MapWebModToVH [['BancsWEB.war' BancsWEB.war,WEB-INF/web.xml default_host]] -noallowServiceRemoteInclude [-MapModulesToServers [['BancsEJB.jar' BancsEJB.jar,META-INF/ejb-jar.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUB Application' BancsWEB.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"]]]]")
        #AdminApp.install(appHome+"/install/"+archiveFileName, "[ -nopreCompileJSPs -installed.ear.destination "+appHome+"/data -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -MapWebModToVH [['BancsWEB.war' BancsWEB.war,WEB-INF/web.xml default_host]] -noallowServiceRemoteInclude [-MapModulesToServers [['BancsEJB.jar' BancsEJB.jar,META-INF/ejb-jar.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUB Application' BancsWEB.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"]]]]")
    else:
       AdminApp.install(appHome+"/install/"+archiveFileName, "[ -nopreCompileJSPs -installed.ear.destination "+appHome+"/data -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",cluster="+clusterName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -MapWebModToVH [[ bcui BancsWEB.war,WEB-INF/web.xml "+clusterName+"_Host ]]-noallowServiceRemoteInclude ]")  
    AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while installing application..", e)    
    System.exit(1)    

loggingjy.info("Application "+appName+" installed successfully.")
