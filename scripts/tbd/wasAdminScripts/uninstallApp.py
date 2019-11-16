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
from java.util import Enumeration
from java.util import StringTokenizer
from javax.management import *
import javax.management.Attribute

#--------------------------------------------------------------
# Initializing Logger
#--------------------------------------------------------------

loggingjy.basicConfig(level=loggingjy.DEBUG, format='%(asctime)s %(levelname)-8s %(message)s', datefmt='%a, %d %b %Y %H:%M:%S', filename='log/uninstall.log', filemode='a')

loggingjy.info("Starting the UnInstallEAIApp script ...")

#---------------------------------------------------------------------
#  Method for print error message on console and in log file
#---------------------------------------------------------------------
def printErrorMessage(logMessage, exceptionObj):
    print "Error occurred. Check uninstall.log in the log directory for more detials."
    loggingjy.error(logMessage)    
    loggingjy.error(exceptionObj.getMessage())


########################################
# INITIALIZING STRING VARIABLES .....  #
########################################

appName=""

########################################################
#						       #	
# LOADING properties from was.config.properties file...#
#						       #	
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
    
      if keyname == "appName":
      	appName=value
    
except Exception, e:
    printErrorMessage("Exception occurred while storing properties into variables...", e)    
    System.exit(1)       

if(appName ==""):
 	loggingjy.error("appName can't be blank. Please enter a valid value.")
	System.exit(1)
try:
    AdminApp.uninstall(appName)
    AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while uninstalling application..."+appName, e)    
    System.exit(1)       
	
loggingjy.info("Application "+appName+" uninstalled successfully...")

