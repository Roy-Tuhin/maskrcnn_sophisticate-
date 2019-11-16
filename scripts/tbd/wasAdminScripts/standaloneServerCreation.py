
######################################################################################################################
# This script is used for creating a stand alone server and configuration of JDBC,JMS, JAAS,
# and System Integration Bus based upon the input from was.config.properties file for Bancs Application.
######################################################################################################################

#IMPORT STATEMENTS
import sys
import re
import loggingjy
from os import environ
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

# WebSphere Application Server spcific properties
wasNDVersion=""
wasRoot=""

# Application Server configuration specific properties
managerProfileName=""
customProfileName=""
cellName=""
standAloneNodeName=""
standAloneManagedServer=""
standAloneManagedServerListenAddress=""

#database specific variables
DBMSMode=""
dbType=""
dbDriverJarPath=""
dbAddressString=""
dbName=""
dbSchemaName=""
dbOnlineUserId=""
dbOnlinePassword=""

## Various port numbers
bootstrapPortList=""
defaultHostList=""
defaultHostSSLList=""
soapPortList=""
sasSSLlistenPortList=""
csivSSLSrvrListenPortList=""
csivSSLMultListenPortList=""
adminHostList=""
unicastPortList=""
adminHostSSLList=""
sipDefaultHostList=""
sipDefaultHostSecureList=""
sipEndPointPortList=""
sipEndPointPortSecureList=""
sipMQPortList=""
sipMQportSecureList=""
orbListenPortList=""

#Bancs Application spcific properties
appDepMode=""
appHome=""
appName=""

# Variables to be used internally in the script
defaultPort=""
defaultPortSSL=""
existingEndPointPort=""
sibEndPointToAppend=""

#Web Server specifc properties
webServerHostList=""
webServerPortList=""

# Server JVM Heap size properties
initialHeapSize=""
maxHeapSize=""

#jvm arguments
jvmArgs=""

hostname=sys.argv[0]


#--------------------------------------------------------------
# Initializing Logger
#--------------------------------------------------------------

loggingjy.basicConfig(level=loggingjy.DEBUG, format='%(asctime)s %(levelname)-8s %(message)s', datefmt='%a, %d %b %Y %H:%M:%S', filename='log/admin.log', filemode='a')

loggingjy.info("Starting the standAloneServerCreation script ...")

#-------------------------------------
# Ports List vvalidation method
#------------------------------------
def isValidPortList(appMode, portType, portList):
    isValid ="true"
    portNumbers=""
    try:
        portNumbers = portList.split(",")
    except Exception, e:
        loggingjy.error("portNumbers")   
        isValid ="false" 
    if(appMode == "s" or appMode =="S"):
      numberOfPorts = len(portNumbers)
      if(numberOfPorts >1):
          loggingjy.error("In case of appDepMode [S] i.e. standAloneServer,you can't specify more than one port. Port name is: "+portType)   
          isValid ="false"
    try:
        for portNumber in portNumbers:
            portValue = Integer.parseInt(portNumber)
            if(portValue > 65536 or portValue < 1024):
              loggingjy.error("Port: "+portType+"  is not in valid range. [1024(min)-655536(max)]")
              isValid ="false"
    except Exception, e:
        loggingjy.error("Port: "+portType+" number: "+portNumber+" is not a valid portNumber.")   
        isValid ="false"
    return isValid
    
#--------------------------------------------------------------
# Property Validation Method
#--------------------------------------------------------------

def validateInput():
  valid="true"
# WebSphere Application server specific validations
  if(wasNDVersion == ""):
       loggingjy.error("wasNDVersion can't be blank")
       valid="false"
  else:
       if(wasNDVersion == "Y" or wasNDVersion =="y" or wasNDVersion =="N" or wasNDVersion =="n"):
            loggingjy.info("wasNDVersion? "+wasNDVersion)
       else:
            loggingjy.error("wasNDVersion is not valid. Entered value is: "+wasNDVersion)
            valid="false"
  if(wasRoot == ""):
    loggingjy.error("wasRoot cannot be blank..")
    valid="false"
  else:
      if File(wasRoot+"/profiles/"+customProfileName).canWrite()!=1:
        loggingjy.error(" : " + wasRoot+"/profiles/"+customProfileName + " dosen't exist or is not writable.")
        valid="false"
      if(wasNDVersion == "Y" or wasNDVersion =="y"):
         if File(wasRoot+"/profiles/"+managerProfileName).canWrite()!=1:
           loggingjy.error(" : " + wasRoot+"/profiles/"+managerProfileName + " dosen't exist or is not writable.")
           valid="false"
        
  # Application Server/s configuration specific properties validations
  if(appDepMode == ""):
       loggingjy.error("appDepMode can't be blank")
       valid="false"
  else:
       if(appDepMode == "C" or appDepMode =="c" or appDepMode =="S" or appDepMode =="s"):
            loggingjy.info("appDepMode is "+appDepMode)
       else:
            loggingjy.error("appDepMode is not valid. Entered value is: "+appDepMode)
            valid="false"
  
  if((appDepMode =="c" or appDepMode == "C")):
      loggingjy.error("This script doesn't support Cluster application deployment currently.")
      valid="false"
  if((appDepMode =="s" or appDepMode == "S")and (standAloneManagedServer=="")):
      loggingjy.error("standAloneManagedServer can't be blank")
      valid="false" 
  if((appDepMode =="s" or appDepMode == "S")and (standAloneManagedServerListenAddress=="")):
      loggingjy.error("standAloneManagedServerListenAddress can't be blank")
      valid="false"
  
  #Profiles related properties validations  
  if(cellName == ""):
    loggingjy.error("cellName can't be blank.")
    valid="false"  
        
  if((appDepMode =="c" or appDepMode == "C")and (managerProfileName=="")):
    loggingjy.error("Manager Profile Name can't be blank when appDepMode is C.")
    valid="false"

  if(customProfileName == ""):
    loggingjy.error("Custom Profile Name can't be blank.")
    valid="false"

  if(standAloneNodeName == ""):
    loggingjy.error("Custom Node Name is not specified, so, using combination of customProfileName_hostnaName.Make sure that node name was created using same combination while creation of custom profile.")

  # Database Specific properties validation
  #For time being it is hard coded to standxAlone
  
  if(DBMSMode==""):
    loggingjy.error("DBMSMode is blank")
    valid="false" 
  else:
    if(DBMSMode=="R" or DBMSMode=="r" or DBMSMode=="S" or DBMSMode=="s"):
      loggingjy.info("DBMSMode is "+DBMSMode)
    else:
      loggingjy.error("Invalid value entered for DBMSMode kindly re enter [expected values R or S ]")
      valid="false"
  if(dbType == ""):
       loggingjy.error("dbType can't be blank")
       valid="false"	
  else:
       if(dbType == "O" or dbType =="o" or dbType =="D" or dbType=="d"):
	    loggingjy.info("dbType is "+dbType)
       else:
            loggingjy.error("dbType is: not valid. Entered value is: "+dbType)
	    valid="false"
  if(dbName == ""):
    loggingjy.error("dbName can't be blank")
    valid="false"
  if((dbType =="D" or dbType=="d") and (DBMSMode=="R" or DBMSMode=="r")):
    loggingjy.error("Cluster DB is not supported in this script for dbType DB2")
    valid="false"  
  if(dbAddressString == ""):
    loggingjy.error("dbAddressString can't be blank")
    valid="false"
  else:
    iptokens = StringTokenizer(dbAddressString, ',')
    while iptokens.hasMoreTokens():
      ipoprt=iptokens.nextToken()
      ipporttok = StringTokenizer(ipoprt, ":")
      dbip=ipporttok.nextToken()
      dbport=ipporttok.nextToken()
      if(dbip=="" or dbport==""):
        valid="false"
        loggingjy.error("dbAddressString not valid. Please re-enter")
      else:
        try:
            portValue=Integer(dbport).intValue()
            if(portValue > 65536 or portValue < 1024):
              loggingjy.error("Invalid DB listen port is not in valid range. [1024(min)-655536(max)]")
              valid="false"
        except:
            loggingjy.error("Invalid DB listen port mentioned. Please re-enter")
            valid="false"
  if(dbDriverJarPath == ""):
    loggingjy.error("dbDriverJarPath can't be blank")
    valid="false"
  ##TODO RAC specific validations. are still pending..
  if((dbType =="D" or dbType=="d") and (dbSchemaName == "")):
    loggingjy.error("dbSchemaName can't be blank")
    valid="false"
  if(dbOnlineUserId == ""):
    loggingjy.error("dbOnlineUserId can't be blank")
    valid="false"
  if(dbOnlinePassword == ""):
    loggingjy.error("dbOnlinePassword can't be blank")
    valid="false"
    
  # Application properties related validation
  if(appHome  == ""):
    loggingjy.error("appHome can't be blank.")
    valid="false"
  else:
       if File(appHome).canWrite()!=1:
         loggingjy.error(" : " + appHome + " doesn't exist or is not writable")
         valid="false"
  if(appName==""):
    loggingjy.error("appName can't be blank")
    valid="false"	
   
  if File(logDir).canWrite()!=1:
    loggingjy.error(" : " + logDir + " doesn't exist or is not writable")
    valid="false"
	
	
  # WebServer specific properties validations
    if(webServerHostList!=""):
       if(webServerPortList==""):
          loggingjy.error("webServerPortList can't be blank if webServerHostList is specified.")
          valid="false"
    if(webServerPortList !=""):
       if(webServerHostList==""):
          loggingjy.error("webServerHostList can't be blank if webServerPortList is specified.")
          valid="false"
    if(webServerHostList!="" and webServerPortList !=""):      
        webServerHosts = webServerHostList.split(",")
        webServerPorts = webServerPortList.split(",")
        if(len(webServerHosts) != len(webServerPorts)):
           loggingjy.error("Number of webServerHosts in webServerHostList must be equal webServerPorts in webServerPortList.")
           valid="false"
        for webServerPortNumber in webServerPorts :
              try:
                  portValue =Integer.parseInt(webServerPortNumber)
                  if(portValue > 65536 or portValue < 1024):
                     loggingjy.error("WebServer Port is not in valid range. [1024(min)-655536(max)]")
                     valid="false"
              except Exception, e:
                  loggingjy.error(" WebServer Port is not valid ")
                  valid="false"
  # Ports related validation  
  if(bootstrapPortList==""):
    loggingjy.error("bootstrapPortList can't be blank")
    valid="false"
  else:
    isValidPort=isValidPortList(appDepMode, "bootStrapPort", bootstrapPortList)  
  if(defaultHostList=="" and defaultHostSSLList==""):
     loggingjy.error("defaultHostList and defaultHostSSLList,both are blank")
     valid="false"
  if(defaultHostList==""):
    loggingjy.warning("defaultHostList is blank")
  else:
    isValidPort=isValidPortList(appDepMode,"defaultHost",defaultHostList)
    if(isValidPort == "false"):
       valid="false"
  if(defaultHostSSLList==""):
    loggingjy.warning("defaultHostSSLList is be blank")
  else:
    isValidPort=isValidPortList(appDepMode, "defaultHostSSL", defaultHostSSLList)
    if(isValidPort == "false"):
       valid="false"
  if(soapPortList!=""):
    isValidPort=isValidPortList(appDepMode, "soapPort", soapPortList)
    if(isValidPort == "false"):
       valid="false"
  if(sasSSLlistenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "sasSSLlistenPort", sasSSLlistenPortList)
    if(isValidPort == "false"):
       valid="false"
  if(csivSSLSrvrListenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "csivSSLSrvrListenPort", csivSSLSrvrListenPortList)
    if(isValidPort == "false"):
       valid="false"
  if(csivSSLMultListenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "csivSSLMultListenPort", csivSSLMultListenPortList)
    if(isValidPort == "false"):
       valid="false"
  if(adminHostList!=""):
    isValidPort=isValidPortList(appDepMode, "adminHost", adminHostList)
    if(isValidPort == "false"):
       valid="false"
  if(unicastPortList!=""):
    isValidPort=isValidPortList(appDepMode, "unicastPort", unicastPortList)
    if(isValidPort == "false"):
       valid="false"
  if(adminHostSSLList!=""):
    isValidPort=isValidPortList(appDepMode, "adminHostSSL", adminHostSSLList)
    if(isValidPort == "false"):
       valid="false"
  if(sipDefaultHostList!=""):
    isValidPort=isValidPortList(appDepMode, "sipDefaultHost", sipDefaultHostList)
    if(isValidPort == "false"):
       valid="false"
  if(sipDefaultHostSecureList!=""):
    isValidPort=isValidPortList(appDepMode, "sipDefaultHostSecure", sipDefaultHostSecureList)
    if(isValidPort == "false"):
       valid="false"
  if(sipEndPointPortList!=""):
    isValidPort=isValidPortList(appDepMode, "sipEndPointPort", sipEndPointPortList)
    if(isValidPort == "false"):
       valid="false"
  if(sipEndPointPortSecureList!=""):
    isValidPort=isValidPortList(appDepMode, "sipEndPointPortSecure", sipEndPointPortSecureList)
    if(isValidPort == "false"):
       valid="false"
  if(sipMQPortList!=""):
    isValidPort=isValidPortList(appDepMode, "sipMQPort", sipMQPortList)
    if(isValidPort == "false"):
       valid="false"
  if(sipMQportSecureList!=""):
    isValidPort=isValidPortList(appDepMode, "sipMQportSecure", sipMQportSecureList)
    if(isValidPort == "false"):
       valid="false"
  if(orbListenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "orbListenPort", orbListenPortList)
    if(isValidPort == "false"):
       valid="false"
  try:
     iHSize = Integer.parseInt(initialHeapSize)
     mHSize = Integer.parseInt(maxHeapSize)
     if(iHSize < 0 or mHSize < 0):
        loggingjy.error("initialHeapSize or maxHeapSize is not a valid positive integer.")
        valid="false"
     if(iHSize > mHSize):
        loggingjy.error("initialHeapSize can't be greater than maxHeapSize.")
        valid="false"

  except Exception, e:
    loggingjy.error("initialHeapSize or maxHeapSize is not a valid positive integer.")
    valid="false"

  
  if(valid=="false"):
    print "Error : Input Validation Failed Check admin.log in thr log directory for more detials"
    print "Exiting...."
    System.exit(1)

########################################################
# 						       #	
# LOADING properties from was.config.properties file...#
#						       #	
########################################################

myProps = Properties()
try:
    myProps.load(FileInputStream(File('was.config.properties')))
    propertyNames = myProps.propertyNames()
except Exception, e:
    printErrorMessage("Error occurred while loading properties file['was.config.properties']...", e)
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
    
      if keyname == "logDir":
      	logDir=value
      if keyname == "wasRoot":
      	wasRoot=value
    
      if keyname == "appName":
      	appName=value
    
      if keyname == "appHome":
      	appHome=value
      	
      if keyname == "cellName":
      	cellName=value
      	
      if keyname == "managerProfileName":
        managerProfileName=value

      if keyname == "customProfileName":
        customProfileName=value

      if keyname == "customNodeName":
        standAloneNodeName=value

      if keyname == "standAloneManagedServer":
      	standAloneManagedServer=value
		
      if keyname == "standAloneManagedServerListenAddress":
        standAloneManagedServerListenAddress=value 	  
      	
      if keyname == "DBMSMode":
        DBMSMode=value

      if keyname == "dbDriverJarPath":
      	dbDriverJarPath=value
      	
      if keyname == "dbName":
        dbName=value

      if keyname == "dbType":
        dbType=value
        
      if keyname == "dbAddressString":
        dbAddressString=value
        
      if keyname == "dbSchemaName":
        dbSchemaName=value
        
      if keyname == "dbOnlineUserId":
        dbOnlineUserId=value
        
      if keyname == "dbOnlinePassword":
      	dbOnlinePassword=value

      if keyname == "wasNDVersion":
        wasNDVersion=value

      if keyname == "appDepMode":
        appDepMode=value

      if keyname == "initialHeapSize":
        initialHeapSize=value

      if keyname == "maxHeapSize":
        maxHeapSize=value
      if keyname == "jvmArgs":
        jvmArgs=value
      
except Exception, e:	
    printErrorMessage("Exception occurred while storing properties into variables...", e) 	
    System.exit(1)

portProp = Properties()
try:
    portProp.load(FileInputStream(File('was.ports.properties')))
    propertyNames = portProp.propertyNames()
except Exception, e:
    printErrorMessage("Error occurred while loading properties file['was.ports.properties']...", e)
    System.exit(1)

#####################################################
#                                                   #
#   STORING PROPERTY VALUES IN VARIABLES....        #
#                                                   #
#####################################################
try:
    while propertyNames.hasMoreElements():
      keyname = str(propertyNames.nextElement())
      value = portProp.getProperty(keyname)

      if keyname == "webServerHostList":
        webServerHostList=value

      if keyname == "webServerPortList":
        webServerPortList=value

      if keyname == "soapPortList":
        soapPortList=value

      if keyname == "bootstrapPortList":
        bootstrapPortList=value

      if keyname == "sasSSLlistenPortList":
        sasSSLlistenPortList=value

      if keyname == "csivSSLSrvrListenPortList":
        csivSSLSrvrListenPortList=value

      if keyname == "csivSSLMultListenPortList":
        csivSSLMultListenPortList=value

      if keyname == "adminHostList":
        adminHostList=value

      if keyname == "defaultHostList":
        defaultHostList=value

      if keyname == "unicastPortList":
        unicastPortList=value

      if keyname == "adminHostSSLList":
        adminHostSSLList=value

      if keyname == "defaultHostSSLList":
        defaultHostSSLList=value

      if keyname == "sipDefaultHostList":
        sipDefaultHostList=value

      if keyname == "sipDefaultHostSecureList":
        sipDefaultHostSecureList=value

      if keyname == "sipEndPointPortList":
        sipEndPointPortList=value

      if keyname == "sipEndPointPortSecureList":
        sipEndPointPortSecureList=value

      if keyname == "sipMQPortList":
        sipMQPortList=value

      if keyname == "sipMQportSecureList":
        sipMQportSecureList=value

      if keyname == "orbListenPortList":
        orbListenPortList=value

except Exception, e:
    printErrorMessage("Exception occurred while storing properties into variables...", e)
    System.exit(1)

if initialHeapSize=="":
  initialHeapSize="256"

if maxHeapSize=="":
  maxHeapSize="512"

if(logDir==""):
  logDir=appHome+"/logs"


#---------------------------------------------------------------------
#  Method to print error message on console and in log file
#---------------------------------------------------------------------
def printErrorMessage(logMessage, exceptionObj):
    print "Error occurred. Check admin.log for more detials."
    loggingjy.error(logMessage)    
    loggingjy.error(exceptionObj.getMessage())

#---------------------------------------------------------------------
#  Method for modifying virutual host port numbers
#---------------------------------------------------------------------
def modifyVirtualHost(cellName,standAloneManagedServer,port):
    VHST = AdminConfig.getid("/Cell:"+cellName+"/VirtualHost:"+standAloneManagedServer+"_Host/")
    if VHST != "":
       try:
         AdminConfig.modify(VHST, [['aliases', [[['port',  Integer(port).intValue()], ['hostname', '*']]]]])
       except Exception,e:
         printErrorMessage("Exception occurred while modifying Virtual Host ...",e)            
         System.exit(1)
    return ""
#-------------------------------------
# Method to split properties
#-------------------------------------
def splitProps(propString):
       propList = []
       tempProp = ''
       inQuotes = 0
       for char in propString[1:-1]:
           if char == ' ':
              if inQuotes == 0:
                   propList.append(tempProp)
                   tempProp = ''
              else:
                   tempProp = tempProp + char
           elif char == '"':
               if inQuotes == 0:
                   inQuotes = 1
               else:
                   inQuotes = 0
           else:
               tempProp = tempProp + char
       if tempProp != '':
          propList.append(tempProp)
       return propList
 
#------------------------------------------------------------------------------
#  Method for configuring JAAS Aplpication Login for Bancs Application
#----------------------------------------------------------------------------
 	
#------------------------------------------------------------------------------
#  Method for configuring JDBC Providers and DataSources for DB2
#----------------------------------------------------------------------------

#AdminTask.listJAASLoginEntries('-interactive')

def configureJDBCForDB2():
  # XA JDBC Provider name
  jdbcProviderName="DB2 Universal JDBC Driver Provider"
  dbAliasName="J2CDBAlias_"+standAloneManagedServer
  dbAliasName2 = "J2CDBAlias_MM_"+standAloneManagedServer
  try:
    # Creating XA JDBC Provider
    DataSource=AdminTask.createJDBCProvider("[-scope Node="+standAloneNodeName+",Server="+standAloneManagedServer+" -databaseType DB2 -providerType '"+jdbcProviderName+"' -implementationType 'Connection pool data source ' -name 'DB2 Universal JDBC Driver Provider' -description 'MM Data Source' -classpath "+dbDriverJarPath+"/db2jcc.jar;"+dbDriverJarPath+"/db2jcc_license_cu.jar;"+dbDriverJarPath+"/db2jcc_license_cisuz.jar -nativePath ${DB2UNIVERSAL_JDBC_DRIVER_NATIVEPATH} ]")
    loggingjy.info("JDBC providers Created...")
  except Exception, e:
    printErrorMessage("Exception occurred while creating JDBC Providers..", e)
    System.exit(1)
 # To create data sources
  try:
     if(DBMSMode=="S" or DBMSMode=="s"):
       # Creating XA Data Source
       dbAddrAndPort = dbAddressString.split(":")
       dbAddr = dbAddrAndPort[0];
       dbPort = dbAddrAndPort[1];
       dbJndiName = "jdbc/MCDataSource";
       newds = AdminTask.createDatasource(DataSource, "[-name MCDataSource -jndiName "+dbJndiName+" -dataStoreHelperClassName com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper -componentManagedAuthenticationAlias "+dbAliasName2+" -containerManagedPersistence false -configureResourceProperties [[databaseName java.lang.String "+dbName+"] [driverType java.lang.Integer 4] [serverName java.lang.String "+dbAddr+"] [portNumber java.lang.Integer "+dbPort+"]]]")
       loggingjy.info("JDBC providers Created...") 
       propSet = AdminConfig.showAttribute(newds, 'propertySet')     
       attr = AdminConfig.showAttribute(propSet, 'resourceProperties')
       oldProps = splitProps(attr)       
       for oldProp in oldProps[:]:
            name = AdminConfig.showAttribute(oldProp, "name")
            if name == "currentSchema":
                AdminConfig.modify(oldProp, [['name', 'currentSchema'], ['value', dbSchemaName]])
       
       loggingjy.info("Data Source Created...")
       #AdminTask.JAASConfigurationEntry('[-loginType application -loginEntryAlias testLoginEntry -loginModules "com.ibm.ws.security.common.auth.module.WSLoginModuleImpl" -authStrategies "REQUIRED"]')
       #AdminTask.listJAASLoginEntries('-interactive')
  except Exception, e:
    printErrorMessage("Exception occurred while creating Data Sources..", e)
    System.exit(1)
#------------------------------------------------------------------------------
#  Method for configuring JDBC Providers and DataSources for Oracle
#----------------------------------------------------------------------------    

def configureJDBCForOracle():
#Non-XA JDBC Provider name
 jdbcProviderName1="Oracle JDBC Driver"

 # J2C DB Alias 
 dbAliasName="J2CDBAlias_MM_"+standAloneManagedServer

# Creating jdbcURL specific to Oracle thin JDBC driver
 jdbcURL="jdbc:oracle:thin:@"+dbAddressString+":"+dbName
 try:
    # Creating Non XA JDBC Provider
    DataSource=AdminTask.createJDBCProvider("[-scope Node="+standAloneNodeName+",Server="+standAloneManagedServer+" -databaseType Oracle -providerType 'Oracle JDBC Driver' -implementationType 'Connection pool data source' -name '"+jdbcProviderName1+"' -description 'Oracle JDBC Driver' -classpath "+dbDriverJarPath+"/ojdbc14.jar -nativePath ]")
    loggingjy.info("JDBC providers Created...")
 except Exception, e:
    printErrorMessage("Exception occurred while creating JDBC Providers..", e)
    System.exit(1)      

# To create data sources
 try:
          if(DBMSMode == "S" or DBMSMode == "s"):
              # Creating Non-XA Data Source
              AdminTask.createDatasource(DataSource, "[-name MCDataSource -jndiName MCDataSource -dataStoreHelperClassName com.ibm.websphere.rsadapter.Oracle10gDataStoreHelper -componentManagedAuthenticationAlias "+dbAliasName+" -configureResourceProperties [[URL java.lang.String "+jdbcURL+"]]]")
          else:   
               dburlstr=""          
	       dburlstr="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST="
	       iptokens = StringTokenizer(dbAddressString, ',')
               while iptokens.hasMoreTokens():
                   ipoprt=iptokens.nextToken()
	           ipporttok = StringTokenizer(ipoprt, ":")
	           dbip=ipporttok.nextToken()
	           dbport=ipporttok.nextToken()
	           dburlstr+="(ADDRESS=(PROTOCOL=TCP)(HOST="+dbip+")(PORT="+dbport+"))"
	       dburlstr+=")(CONNECT_DATA=(SERVICE_NAME="+dbName+")))"
               # Creating Non-XA Data Source
               AdminTask.createDatasource(DataSource, "[-name MCDataSource -jndiName MCDataSource -dataStoreHelperClassName com.ibm.websphere.rsadapter.Oracle10gDataStoreHelper -componentManagedAuthenticationAlias "+dbAliasName+" -configureResourceProperties [[URL java.lang.String "+dburlstr+"]]]")
          loggingjy.info("Data Sources Created...")	   
 except Exception, e:
    printErrorMessage("Exception occurred while creating Data Sources..", e)
    System.exit(1)

def changeCookiePath(serverName):
   try:
     # Getting server object
     server=AdminConfig.getid("/Server:"+serverName+"/")
     smgr=AdminConfig.list('SessionManager', server)
     cookiePath='/bcui/'
     AdminConfig.modify(smgr, [['enableCookies', 'true'], ['defaultCookieSettings', [['path', cookiePath]]]])

   except Exception, e:
    printErrorMessage("Exception occurred while changing cookie path of server "+serverName +" ...", e)
    System.exit(1)


#----------------------------------------------------------------------------
# Method to change the initial and maximum heap size of spcified server
#----------------------------------------------------------------------------
def changeHeapSizeOfServer(serverName,initialHeapSize,maxHeapSize,jvmArgs):
   try:
        # Getting server object
        server = AdminConfig.getid("/Server:"+serverName+"/")

        # Getting processDefinitins object
        processDefinitions =  AdminConfig.showAttribute(server, 'processDefinitions')
        processDefinitions = processDefinitions.replace("]", "")
        processDefinitions = processDefinitions.replace("[", "")

        # Getting jvm entries
        jvmEntries = AdminConfig.showAttribute(processDefinitions, 'jvmEntries')
        jvmEntries = jvmEntries.replace("]", "")
        jvmEntries = jvmEntries.replace("[", "")

        # setting initial and maximum heap size
        AdminConfig.modify(jvmEntries, [['initialHeapSize', java.lang.Integer(initialHeapSize).intValue()], ['maximumHeapSize', java.lang.Integer(maxHeapSize).intValue()],['genericJvmArguments',jvmArgs]])
   except Exception, e:
    printErrorMessage("Exception occurred while changing heap size of server "+serverName +" ...", e)
    System.exit(1)

#-------------------------------------------------------------------------------------
#
# Method  to change the max connection Pool size of MCDataSource and MCQueryDataSource
# data Source for a particular server
#
#-------------------------------------------------------------------------------------
def changeMaxConnectionPool(serverName):
  try:
      maxConnectionValue = "40"
      lineSeparator=java.lang.System.getProperty('line.separator')
      server = AdminConfig.getid("/Server:"+serverName+"/")
      dsList = AdminConfig.list('DataSource', server)
      if(dsList !=""):
          dsArr = dsList.split(lineSeparator)
	  numberOfDataSources=len(dsArr)
	  counter = 0
	  while (counter <  numberOfDataSources):
	     dsEntry = dsArr[counter]
             # Because jython does not support indexOf or substring methods so wee need to use a trick here
             mcDataSource=dsEntry.split("MCDataSource")
	     if(len(mcDataSource)>1):
                 connPool = AdminConfig.showAttribute(dsEntry, 'connectionPool')
	         AdminConfig.modify(connPool, [['maxConnections', maxConnectionValue]])
             counter = counter + 1	   
  except Exception, e:
     printErrorMessage("Exception occurred while setting maxConnection of Data Source Connection pool for server "+serverName +" ...", e)
     System.exit(1)




if(standAloneNodeName ==""):
  standAloneNodeName=customProfileName+"_"+hostname
 


###################
#                 #
# Server creation #
#                 #
###################

if(wasNDVersion =="Y" or wasNDVersion =="y"):	
	try:
    		AdminTask.createApplicationServer(standAloneNodeName, "[-name "+standAloneManagedServer+" -templateName default ]")
    		loggingjy.info("Server Created..")
	except Exception,e:
    		printErrorMessage("Exception occurred while creating Server..",e)
    		System.exit(1)



#####################################
#				    #	
# Setting up secuirty configuration #
#				    #	
#####################################
try:
    security=AdminConfig.getid("/Cell:"+cellName+"/Security:/")
except Exception, e:    
    printErrorMessage("Exception occurred while accessing security on cell:["+cellName+"].", e)    
    System.exit(1)


# Setting up J2C Alias Configuration
try:
    AdminConfig.required('JAASAuthData')
    aliasName = "J2CDBAlias_MM_"+standAloneManagedServer
    alias = ['alias', aliasName]
    userid = ['userId', dbOnlineUserId]
    password = ['password', dbOnlinePassword]
    jaasAttrs = [alias, userid, password]
    AdminConfig.create('JAASAuthData', security, jaasAttrs)    
    loggingjy.info("J2C Alias Created...")
except Exception, e:
    printErrorMessage("Exception occurred while creating J2C Alias configuration with name :"+aliasName, e)
    System.exit(1)    

##################### JAAS Application Modules configuration ###################

# Locate Application Login Config
try:
    slc = AdminConfig.showAttribute(security, "applicationLoginConfig")
except Exception, e:
    printErrorMessage("Exception occurred while locating Application Login Config.", e)
    System.exit(1)    


#############################
#                           # 
# JDBC Configuration        #
#                           #
#############################
if(dbType=="O" or dbType =="o"):
    configureJDBCForOracle()
else:
    configureJDBCForDB2()



# Fetching the Server's default-host port and default-host-secure ports

try:
    node = AdminConfig.getid("/Node:"+standAloneNodeName+"/")
    serverEntries = AdminConfig.list('ServerEntry', node).split(java.lang.System.getProperty('line.separator'))
    for serverEntry in serverEntries:
      sName = AdminConfig.showAttribute(serverEntry, "serverName")
      if sName == standAloneManagedServer:
        temp = AdminConfig.showAttribute(serverEntry, "specialEndpoints")
        specialEndPoints = temp.split(" ")
        for tmp in specialEndPoints:
          specialEndPoint = tmp.replace("[","")
          specialEndPoint = specialEndPoint.replace("]","")
          endPointNm = AdminConfig.showAttribute(specialEndPoint, "endPointName")
          if endPointNm == "WC_defaulthost":
             ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
             portValue = AdminConfig.show(ePoint, 'port')
             portValue = portValue.replace("[port ","")
             defaultPort = portValue.replace("]","")
          if endPointNm == "WC_defaulthost_secure":
             ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
             portValue = AdminConfig.show(ePoint, 'port')
             portValue = portValue.replace("[port ","")
             defaultPortSSL = portValue.replace("]","")
   	  if endPointNm == "SIB_ENDPOINT_ADDRESS":
             ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
             portValue = AdminConfig.show(ePoint, 'port')
             portValue = portValue.replace("[port ","")
             existingEndPointPort = portValue.replace("]","")

except Exception,e:
    printErrorMessage("Exception occurred etching the Server's default-host port and default-host-secure ports ...",e)
    System.exit(1)
 
## Creating Virtual Host

try:
    cell = AdminConfig.getid("/Cell:"+cellName+"/")
    vtempl = AdminConfig.listTemplates('VirtualHost', 'default_host')
    vHostName = standAloneManagedServer+"_Host"
    vth=AdminConfig.createUsingTemplate('VirtualHost', cell, [['name', vHostName]], vtempl)
    AdminConfig.modify(vth, [['aliases', [[['port', Integer(defaultPort).intValue()], ['hostname', '*']], [['port', Integer(defaultPortSSL).intValue()], ['hostname', '*']]]]])
    
    if(webServerHostList!="" and webServerPortList !=""):      
        webServerHosts = webServerHostList.split(",")
        webServerPorts = webServerPortList.split(",")
        counter=0
        for webServerPort in webServerPorts:		       
           AdminConfig.modify(vth, [['aliases', [[['port', Integer(webServerPort).intValue()], ['hostname', webServerHosts[counter]]]]]])
           counter = counter + 1
except Exception, e:
    printErrorMessage("Exception occurred while creating Virtual Host ...", e)
    System.exit(1)
loggingjy.info("Virtual Hosts Created")

#####################################################################
# Modifying the spcified port numbers of the server and virtul host
################3#####################################################

try:
	node = AdminConfig.getid("/Node:"+standAloneNodeName+"/")
	server= AdminConfig.getid("/Node:"+standAloneNodeName+"/Server:"+standAloneManagedServer+"/")

	serverEntries = AdminConfig.list('ServerEntry', node).split(java.lang.System.getProperty('line.separator'))
	for serverEntry in serverEntries:
	  sName = AdminConfig.showAttribute(serverEntry, "serverName")
	  if sName == standAloneManagedServer:
	    temp = AdminConfig.showAttribute(serverEntry, "specialEndpoints")
	    specialEndPoints = temp.split(" ")
	    for tmp in specialEndPoints:
	      specialEndPoint = tmp.replace("[","")
	      specialEndPoint = specialEndPoint.replace("]","")
	      endPointNm = AdminConfig.showAttribute(specialEndPoint, "endPointName")
	      if endPointNm == "BOOTSTRAP_ADDRESS" and bootstrapPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", bootstrapPortList]])

	      if endPointNm == "SOAP_CONNECTOR_ADDRESS" and soapPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", soapPortList]])

	      if endPointNm == "SAS_SSL_SERVERAUTH_LISTENER_ADDRESS" and sasSSLlistenPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", sasSSLlistenPortList]])

	      if endPointNm == "CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS" and csivSSLSrvrListenPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", csivSSLSrvrListenPortList]])

	      if endPointNm == "CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS" and csivSSLMultListenPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", csivSSLMultListenPortList]])

	      if endPointNm == "WC_adminhost" and adminHostList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", adminHostList]])

	      if endPointNm == "WC_defaulthost" and defaultHostList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", defaultHostList]])
	           modifyVirtualHost(cellName,standAloneManagedServer,defaultHostList)

	      if endPointNm == "DCS_UNICAST_ADDRESS" and unicastPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", unicastPortList]])

	      if endPointNm == "WC_adminhost_secure" and adminHostSSLList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", adminHostSSLList]])

	      if endPointNm == "WC_defaulthost_secure" and defaultHostSSLList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", defaultHostSSLList]])
	           modifyVirtualHost(cellName,standAloneManagedServer,defaultHostSSLList)

	      if endPointNm == "SIP_DEFAULTHOST" and sipDefaultHostList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", sipDefaultHostList]])

	      if endPointNm == "SIP_DEFAULTHOST_SECURE" and sipDefaultHostSecureList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", sipDefaultHostSecureList]])

	      if endPointNm == "SIB_ENDPOINT_ADDRESS" and sipEndPointPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
	           AdminConfig.modify(ePoint, [["port", sipEndPointPortList]])

	      if endPointNm == "SIB_ENDPOINT_SECURE_ADDRESS" and sipEndPointPortSecureList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")                   
                   AdminConfig.modify(ePoint, [["port", sipEndPointPortSecureList]])

	      if endPointNm == "ORB_LISTENER_ADDRESS" and orbListenPortList != "":
	           ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
	           AdminConfig.modify(ePoint, [["port", orbListenPortList]])
except Exception, e:
    printErrorMessage("Exception occurred while modifying ports...", e)    
    System.exit(1)

try:
    if(sipEndPointPortList != ""):
        sibEndPointToAppend = standAloneManagedServerListenAddress+":"+sipEndPointPortList+":BootstrapBasicMessaging"
    else:
        sibEndPointToAppend = standAloneManagedServerListenAddress+":"+ existingEndPointPort+":BootstrapBasicMessaging" 
   
except Exception, e:
    printErrorMessage("Exception occurred while modifying providerEndPoints for Queue Connection Factories...", e)
    e.printStackTrace()
    System.exit(1)

AdminConfig.save()    
loggingjy.info("All configurations done successfully...")
print("All configurations done successfully.. ")

