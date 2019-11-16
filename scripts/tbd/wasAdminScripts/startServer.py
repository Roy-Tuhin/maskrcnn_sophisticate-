
#IMPORT STATEMENTS
import sys
import re
import loggingjy
from os  import environ
from java.lang import System
from java.lang import Exception
from java.util import Properties
from java.io import FileInputStream
from java.io import File
from javax.management import *
import javax.management.Attribute

########################################
# INITIALIZING STRING VARIABLES .....  #
########################################

cellName=""
standAloneNodeName=""
standAloneServerName=""

#--------------------------------------------------------------
# Initializing Logger
#--------------------------------------------------------------
loggingjy.basicConfig(level=loggingjy.DEBUG,format='%(asctime)s %(levelname)-8s %(message)s',datefmt='%a, %d %b %Y %H:%M:%S',filename='log/setup_admin.log',filemode='a')
loggingjy.info("Starting the Install App script ...")
#---------------------------------------------------------------------
#  Method for print error message on console and in log file
#---------------------------------------------------------------------
def printErrorMessage(logMessage,exceptionObj):
    print "Error occurred. Check setup_admin.log in the log directory for more detials."
    loggingjy.error(logMessage)    
    loggingjy.error(exceptionObj.getMessage())

########################################################
#						       #	
# LOADING properties from was.config.properties file...#
#  						       #	
########################################################

myProps = Properties()
try:
    myProps.load(FileInputStream(File('was.config.properties')))
    propertyNames = myProps.propertyNames()
except Exception,e:
    printErrorMessage("Exception occurred while loading properties file['was.config.properties']...",e)
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
    
      if keyname == "cellName":
      	cellName=value
      	
      if keyname == "nodeName":
      	standAloneNodeName=value
      	
      if keyname == "standAloneServerName":
      	standAloneServerName=value
      	

except Exception,e:
    printErrorMessage("Exception occurred while storing properties into variables...",e)
    System.exit(1)       
#Validating 
valid="true"
if(cellName==""):
    loggingjy.error("cellName can't be blank.")
    valid="false"
if(standAloneNodeName==""):
    loggingjy.error("standAloneNodeName can't be blank.")
    valid="false"
if(standAloneServerName==""):	
    loggingjy.error("standAloneServerName can't be blank.")
    valid="false"
if(valid=="false"):
    loggingjy.error("Invalid property values spcified.")
    loggingjy.error("Exiting..")
    System.exit(1)

print "Starting Server : "+standAloneServerName
try:
    server=AdminConfig.getid("/Server:"+standAloneServerName+"/")
    serverStr=AdminConfig.getObjectName(server)
    if serverStr == "":
       AdminControl.invoke("WebSphere:name=NodeAgent,process=nodeagent,platform=common,node="+standAloneNodeName+",diagnosticProvider=true,version=6.1.0.2,type=NodeAgent,mbeanIdentifier=NodeAgent,cell="+cellName+",spec=1.0", "launchProcess", "["+standAloneServerName+"]", "[java.lang.String]")
       loggingjy.info("Server Stared..."+standAloneServerName)
    else:
       loggingjy.error("Server "+standAloneServerName+" already started")
except Exception,e:
    printErrorMessage("Exception occurred while starting server:"+ standAloneServerName,e)
    System.exit(1)
  


