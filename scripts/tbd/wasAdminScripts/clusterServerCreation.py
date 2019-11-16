#------------------------------------------------------------------------------------------------------------------------------
# This script is used for creating cluster and cluster memebers and configuration of JDBC,JMS, JAAS, 
# and Service Integration Bus based upon the input from was.config.properties file for EAI Application.
#----------------------------------------------------------------------------------------------------------------------------------

#IMPORT STATEMENTS
import sys
import re
import loggingjy
from os  import environ
from java.lang import System
from java.lang import Exception
from java.lang import Integer
from java.lang import Integer
from java.lang import String
from java.util import Properties
from java.io import FileInputStream
from java.io import File
from java.util import Enumeration
from java.util import StringTokenizer
from java.util import ArrayList
from java.util import HashMap
from javax.management import *
import javax.management.Attribute


#----------------------------------------------------------------
# INITIALIZING STRING VARIABLES .....  
#---------------------------------------------------------------

# WebSphere Application Server spcific properties
wasNDVersion=""
wasRoot=""

# Application Server configuration specific properties
managerProfileName=""
cellName=""
customNodeNameList=""
#nodeName=""
clusterName=""
ManagedServersList=""
ManagedServersListenAddressList=""

# Number of servers in the cluster.
numberOfServers=""

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

#EAI Application spcific properties
appDepMode=""
appHome=""
appName=""

#Web Server specifc properties
webServerHostList=""
webServerPortList=""

# HashMaps storing serverPorts (Used internally in script)
serverAndPortsMap = HashMap()
oldServerPortNamesAndNumbersMap = HashMap()

# Server JVM Heap size properties
initialHeapSize=""
maxHeapSize=""


#--------------------------------------------------------------
# Initializing Logger
#--------------------------------------------------------------

loggingjy.basicConfig(level=loggingjy.DEBUG, format='%(asctime)s %(levelname)-8s %(message)s', datefmt='%a, %d %b %Y %H:%M:%S', filename='log/admin.log', filemode='a')

loggingjy.info("Starting the clusterCreation script ...")

#---------------------------------------------------------------------
#  Method to print error message on console and in log file
#---------------------------------------------------------------------
def printErrorMessage(logMessage, exceptionObj):
    print "Error occurred. Check admin.log in log directory for more details."
    loggingjy.error(logMessage)    
    loggingjy.error(exceptionObj.getMessage())

       
#-------------------------------------
# Ports List Validation method
#------------------------------------
def isValidPortList(appMode, portType, portList, serversList):
    isValid ="true"
    portNumbers=""	
    try:
        portNumbers = portList.split(",")
    except Exception, e:
        loggingjy.error("portNumbers are not properly comma separated.")   
        isValid ="false" 		
		
    if(appMode == "s" or appMode =="S"):
      numberOfPorts = len(portNumbers)
      if(numberOfPorts >1):
          loggingjy.error("In case of appDepMode [S] i.e. standAloneServer,you can't specify more than one port. Port name is: "+portType)   
          isValid ="false"
		  
    sList = serversList.split(",");
    serversCount = len(sList)
    if(serversCount != len(portNumbers)):
	    loggingjy.error("Number of servers in ManagedServersList and number of ports of portType "+portType+" must be equal.")
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

#---------------------------------------------------------------------
#  Method for modifying virutual host port numbers
#---------------------------------------------------------------------
def modifyVirtualHost(cellName, standAloneManagedServer, port):
    VHST = AdminConfig.getid("/Cell:"+cellName+"/VirtualHost:"+standAloneManagedServer+"_Host/")
    if VHST != "":
        try:
            AdminConfig.modify(VHST, [['aliases', [[['port', Integer(port).intValue()], ['hostname', '*']]]]])
        except Exception, e:
            printErrorMessage("Exception occurred while modifying Virtual Host ...", e)            
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
#  Method for configuring JDBC Providers and DataSources for DB2
#----------------------------------------------------------------------------
def configureJDBCForDB2():
  # XA JDBC Provider name
  jdbcProviderName="DB2 Universal JDBC Driver Provider"
  dbAliasName="J2CDBAlias_EAI_"+clusterName
  try:
    # Creating Non XA JDBC Provider
    DataSource=AdminTask.createJDBCProvider("[-scope Cluster="+clusterName+" -databaseType DB2 -providerType '"+jdbcProviderName+"' -implementationType 'Connection pool data sourc' -name 'DB2 Universal JDBC Driver Provider' -description 'EAI Data Source' -classpath "+dbDriverJarPath+"/db2jcc.jar;"+dbDriverJarPath+"/db2jcc_license_cu.jar;"+dbDriverJarPath+"/db2jcc_license_cisuz.jar -nativePath ${DB2UNIVERSAL_JDBC_DRIVER_NATIVEPATH} ]")
    loggingjy.info("JDBC providers Created...")
  except Exception, e:
    printErrorMessage("Exception occurred while creating JDBC Providers..", e)
    System.exit(1)
 # To create data sources
  try:
     if(DBMSMode=="S" or DBMSMode=="s"):
       # Creating Non XA Data Source
       dbAddrAndPort = dbAddressString.split(":")
       dbAddr = dbAddrAndPort[0];
       dbPort = dbAddrAndPort[1];
       newds = AdminTask.createDatasource(DataSource, "[-name MCDataSource -jndiName MCDataSource -dataStoreHelperClassName com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper -componentManagedAuthenticationAlias "+dbAliasName+" -containerManagedPersistence false -configureResourceProperties [[databaseName java.lang.String "+dbName+"] [driverType java.lang.Integer 4] [serverName java.lang.String "+dbAddr+"] [portNumber java.lang.Integer "+dbPort+"]]]")
       propSet = AdminConfig.showAttribute(newds, 'propertySet')     
       attr = AdminConfig.showAttribute(propSet, 'resourceProperties')
       oldProps = splitProps(attr)       
       for oldProp in oldProps[:]:
            name = AdminConfig.showAttribute(oldProp, "name")
            if name == "currentSchema":
                AdminConfig.modify(oldProp, [['name', 'currentSchema'], ['value', dbSchemaName]])
       loggingjy.info("Data Source Created...")

  except Exception, e:
    printErrorMessage("Exception occurred while creating Data Sources..", e)
    System.exit(1)

#------------------------------------------------------------------------------
#  Method for configuring JDBC Providers and DataSources for Oracle
#----------------------------------------------------------------------------    
def configureJDBCForOracle():
#Non-XA JDBC Provider name
 jdbcProviderName1="Oracle JDBC Driver"

# Creating jdbcURL specific to Oracle thin JDBC driver
 jdbcURL="jdbc:oracle:thin:@"+dbAddressString+":"+dbName

 dbAliasName="J2CDBAlias_EAI_"+clusterName

 try:
    # Creating Non XA JDBC Provider
    DataSource=AdminTask.createJDBCProvider("[-scope Cluster="+clusterName+" -databaseType Oracle -providerType 'Oracle JDBC Driver' -implementationType 'Connection pool data source' -name '"+jdbcProviderName1+"' -description 'Oracle JDBC Driver' -classpath "+dbDriverJarPath+"/ojdbc14.jar -nativePath ]")
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


#----------------------------------------------------------------
# Method to modify various ports of servers in the cluster
#----------------------------------------------------------------
def modifyPorts(cellName, nodeName):
        try:
        	node = AdminConfig.getid("/Node:"+nodeName+"/")
               	serverEntries = AdminConfig.list('ServerEntry', node).split(java.lang.System.getProperty('line.separator'))
        	for serverEntry in serverEntries:
        	  sName = AdminConfig.showAttribute(serverEntry, "serverName")
        	  portNameAndNumbersMap = serverAndPortsMap.get(sName)
        	  if(portNameAndNumbersMap is not None):        	      
        	        temp = AdminConfig.showAttribute(serverEntry, "specialEndpoints")
        	        specialEndPoints = temp.split(" ")
        	        for tmp in specialEndPoints:
        	          specialEndPoint = tmp.replace("[", "")
        	          specialEndPoint = specialEndPoint.replace("]", "")
        	          endPointNm = AdminConfig.showAttribute(specialEndPoint, "endPointName")
        	          bootstrapPort = portNameAndNumbersMap.get("BOOTSTRAP_ADDRESS")
        	          if endPointNm == "BOOTSTRAP_ADDRESS" and bootstrapPort is not None and bootstrapPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", bootstrapPort]])
        	               
        	          soapPort = portNameAndNumbersMap.get("SOAP_CONNECTOR_ADDRESS")         
        	          if endPointNm == "SOAP_CONNECTOR_ADDRESS" and soapPort is not None and soapPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", soapPort]])
                      
        	          sasSSLlistenPort = portNameAndNumbersMap.get("SAS_SSL_SERVERAUTH_LISTENER_ADDRESS")         
        	          if endPointNm == "SAS_SSL_SERVERAUTH_LISTENER_ADDRESS" and sasSSLlistenPort is not None and sasSSLlistenPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", sasSSLlistenPort]])
                      
        	          csivSSLSrvrListenPort = portNameAndNumbersMap.get("CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS")         
        	          if endPointNm == "CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS" and csivSSLSrvrListenPort is not None  and csivSSLSrvrListenPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", csivSSLSrvrListenPort]])
                      
        	          csivSSLMultListenPort = portNameAndNumbersMap.get("CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS")         
        	          if endPointNm == "CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS" and csivSSLMultListenPort is not None  and csivSSLMultListenPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", csivSSLMultListenPort]])
                      
        	          adminHost = portNameAndNumbersMap.get("WC_adminhost")         
        	          if endPointNm == "WC_adminhost"  and adminHost is not None and adminHost != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", adminHost]])
                      
        	          defaultHost = portNameAndNumbersMap.get("WC_defaulthost")         
        	          if endPointNm == "WC_defaulthost"  and defaultHost is not None and defaultHost != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", defaultHost]])
        	               modifyVirtualHost(cellName, clusterName, defaultHost)
                      
        	          unicastPort = portNameAndNumbersMap.get("DCS_UNICAST_ADDRESS")         
        	          if endPointNm == "DCS_UNICAST_ADDRESS" and unicastPort is not None and unicastPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", unicastPort]])
                      
        	          adminHostSSL = portNameAndNumbersMap.get("WC_adminhost_secure")         
        	          if endPointNm == "WC_adminhost_secure" and adminHostSSL is not None and adminHostSSL != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", adminHostSSL]])
                      
        	          defaultHostSSL = portNameAndNumbersMap.get("WC_defaulthost_secure")         
        	          if endPointNm == "WC_defaulthost_secure" and defaultHostSSL is not None and defaultHostSSL != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", defaultHostSSL]])
        	               modifyVirtualHost(cellName, clusterName, defaultHostSSL)
                      
        	          sipDefaultHost = portNameAndNumbersMap.get("SIP_DEFAULTHOST")         
        	          if endPointNm == "SIP_DEFAULTHOST" and sipDefaultHost is not None and sipDefaultHost != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", sipDefaultHost]])
                      
        	          sipDefaultHostSecure = portNameAndNumbersMap.get("SIP_DEFAULTHOST_SECURE")         
        	          if endPointNm == "SIP_DEFAULTHOST_SECURE" and sipDefaultHostSecure is not None and sipDefaultHostSecure != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", sipDefaultHostSecure]])
                      
        	          sipEndPointPort = portNameAndNumbersMap.get("SIB_ENDPOINT_ADDRESS")         
        	          if endPointNm == "SIB_ENDPOINT_ADDRESS" and sipEndPointPort is not None and sipEndPointPort!= "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", sipEndPointPort]])
                      
        	          sipEndPointPortSecure = portNameAndNumbersMap.get("SIB_ENDPOINT_SECURE_ADDRESS")         
        	          if endPointNm == "SIB_ENDPOINT_SECURE_ADDRESS" and sipEndPointPortSecure is not None and sipEndPointPortSecure != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")	   
                               AdminConfig.modify(ePoint, [["port", sipEndPointPortSecure]])
                      
        	          orbListenPort = portNameAndNumbersMap.get("ORB_LISTENER_ADDRESS")         
        	          if endPointNm == "ORB_LISTENER_ADDRESS" and orbListenPort is not None and orbListenPort != "":
        	               ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
        	               AdminConfig.modify(ePoint, [["port", orbListenPort]])
        except Exception, e:
            printErrorMessage("Exception occurred while modifying ports...", e)
            System.exit(1)
            


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
       if(wasNDVersion == "Y" or wasNDVersion =="y"):
            loggingjy.info("wasNDVersion "+wasNDVersion)
       else:
            loggingjy.error("wasNDVersion is not valid. wasNDVersion  is required for clustering setup.")
            valid="false"

  if(managerProfileName == ""):
    loggingjy.error("Manager Profile Name can't be blank.")
    valid="false"
  if(customNodeNameList == ""):
    loggingjy.error("customNodeNameList can't be blank.")
    valid="false"
  if(wasRoot == ""):
    loggingjy.error("wasRoot cannot be blank..")
    valid="false"
  else:
      if File(wasRoot+"/profiles/"+managerProfileName).canWrite()!=1:
        loggingjy.error(" : " + wasRoot+"/profiles/"+managerProfileName + " doesn't exist or is not writable.")
        valid="false"      
  # Application Server/s configuration specific properties validations
  if(appDepMode == ""):
       loggingjy.error("appDepMode can't be blank")
       valid="false"
  else:
       if(appDepMode == "C" or appDepMode =="c"):
            loggingjy.info("appDepMode is "+appDepMode)
       else:
            loggingjy.error("appDepMode is not valid. It should be [C] or [c] for cluster setup. Entered value is: "+appDepMode)
            valid="false"
  if(clusterName==""):
      loggingjy.error("ClusterName can't be blank")
      valid="false"  
  if(ManagedServersList ==""):
      loggingjy.error("ManagedServersList can't be blank")
      valid="false"  
  if(ManagedServersListenAddressList==""):
      loggingjy.error("ManagedServersListenAddressList can't be blank")
      valid="false"
  managedServers = ManagedServersList.split(",")
  managedServersAddr = ManagedServersListenAddressList.split(",")
  if(len(managedServers) != len(managedServersAddr)):
      loggingjy.error("Number of managedServers in ManagedServersListenAddressList and listenAddresses in ManagedServersListenAddressList must be equal.")
      valid="false"  
  # Checking uniqueness of server Names	  
  mServersList = ArrayList()	  
  for mServer in managedServers :
      if (mServersList.contains(mServer) == 1) :
	       loggingjy.error("Server names must be unique..")   
	       valid ="false"
	       break
      mServersList.add(mServer)
  #Profiles related properties validations  
  if(cellName == ""):
    loggingjy.error("cellName can't be blank.")
    valid="false"    
  # Database Specific properties validation 
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
    
  # EAI application properties related validation
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
    isValidPort=isValidPortList(appDepMode, "bootStrapPort", bootstrapPortList, ManagedServersList)  
  if(defaultHostList==""):
    loggingjy.error("defaultHostList can't be blank")
    valid="false"
  else:
    isValidPort=isValidPortList(appDepMode, "defaultHost", defaultHostList, ManagedServersList)
  if(defaultHostSSLList==""):
    loggingjy.error("defaultHostSSLList can't be blank")
    valid="false"
  else:
    isValidPort=isValidPortList(appDepMode, "defaultHostSSL", defaultHostSSLList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(soapPortList!=""):
    isValidPort=isValidPortList(appDepMode, "soapPort", soapPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sasSSLlistenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "sasSSLlistenPort", sasSSLlistenPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(csivSSLSrvrListenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "csivSSLSrvrListenPort", csivSSLSrvrListenPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(csivSSLMultListenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "csivSSLMultListenPort", csivSSLMultListenPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(adminHostList!=""):
    isValidPort=isValidPortList(appDepMode, "adminHost", adminHostList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(unicastPortList!=""):
    isValidPort=isValidPortList(appDepMode, "unicastPort", unicastPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(adminHostSSLList!=""):
    isValidPort=isValidPortList(appDepMode, "adminHostSSL", adminHostSSLList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sipDefaultHostList!=""):
    isValidPort=isValidPortList(appDepMode, "sipDefaultHost", sipDefaultHostList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sipDefaultHostSecureList!=""):
    isValidPort=isValidPortList(appDepMode, "sipDefaultHostSecure", sipDefaultHostSecureList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sipEndPointPortList!=""):
    isValidPort=isValidPortList(appDepMode, "sipEndPointPort", sipEndPointPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sipEndPointPortSecureList!=""):
    isValidPort=isValidPortList(appDepMode, "sipEndPointPortSecure", sipEndPointPortSecureList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sipMQPortList!=""):
    isValidPort=isValidPortList(appDepMode, "sipMQPort", sipMQPortList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(sipMQportSecureList!=""):
    isValidPort=isValidPortList(appDepMode, "sipMQportSecure", sipMQportSecureList, ManagedServersList)
    if(isValidPort == "false"):
       valid="false"
  if(orbListenPortList!=""):
    isValidPort=isValidPortList(appDepMode, "orbListenPort", orbListenPortList, ManagedServersList)
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
    print "Error : Input Validation Failed Check admin.log in log directory for more detials"
    print "Exiting...."
    System.exit(1)


#--------------------------------------------------------------------------------------------
#
#	Method to change the cookie path for a particular server
#
#--------------------------------------------------------------------------------------------
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
def changeHeapSizeOfServer(serverName, initialHeapSize, maxHeapSize):
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
        AdminConfig.modify(jvmEntries, [['initialHeapSize', java.lang.Integer(initialHeapSize).intValue()], ['maximumHeapSize', java.lang.Integer(maxHeapSize).intValue()]])
   except Exception, e:
    printErrorMessage("Exception occurred while changing heap size of server "+serverName +" ...", e)
    System.exit(1)
	
	
#-------------------------------------------------------------------------------------
#
# Method  to change the max connection Pool size of MCDataSource and MCQueryDataSource
# data Source for a particular server
#
#-------------------------------------------------------------------------------------
def changeMaxConnectionPool(clusterName):
  try:
      maxConnectionValue = "40"
      lineSeparator=java.lang.System.getProperty('line.separator')
      cluster = AdminConfig.getid("/ServerCluster:"+clusterName+"/")
      dsList = AdminConfig.list('DataSource', cluster)
      if(dsList !=""):
          dsArr = dsList.split(lineSeparator)
	  numberOfDataSources=len(dsArr)
	  counter = 0
	  while (counter <  numberOfDataSources):
	     dsEntry = dsArr[counter]
             # Because jython does not support indexOf or substring methods so wee need to use a trick here
             mcDataSource=dsEntry.split("MCDataSource")
             #mcQueryDataSource=dsEntry.split("MCQueryDataSource")
	     if(len(mcDataSource)>1):
                 connPool = AdminConfig.showAttribute(dsEntry, 'connectionPool')
	         AdminConfig.modify(connPool, [['maxConnections', maxConnectionValue]])
             counter = counter + 1	   
  except Exception, e:
     printErrorMessage("Exception occurred while setting maxConnection of Data Source Connection pool for cluster "+clusterName +" ...", e)
     System.exit(1)
#--------------------------------------------------------------------------------
#                                                   
# LOADING properties from was.config.properties file...
#                                                   
#--------------------------------------------------------------------------------

try:
    myProps = Properties()
    myProps.load(FileInputStream(File('was.config.properties')))
    propertyNames = myProps.propertyNames()
except Exception, e:
    printErrorMessage("Exception occurred while loading properties file['was.config.properties']...", e)
    System.exit(1)


#------------------------------------------------------------------------------------
#						    	
#   STORING PROPERTY VALUES IN VARIABLES....        
#						    	
#------------------------------------------------------------------------------------
try:
    while propertyNames.hasMoreElements():
      keyname = str(propertyNames.nextElement())
      value = myProps.getProperty(keyname)
    
      if keyname == "wasRoot":
      	 wasRoot=value
    
      if keyname == "appName":
      	 appName=value
    
      if keyname == "appHome":
      	 appHome=value
      	
      if keyname == "cellName":
      	 cellName=value
      	
      if keyname == "ClusterName":
      	 clusterName=value
      	
      if keyname == "ManagedServersList":
         ManagedServersList=value

      if keyname == "ManagedServersListenAddressList":
         ManagedServersListenAddressList=value

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
      
      if keyname == "wasNDVersion":
         wasNDVersion=value

      if keyname == "appDepMode":
         appDepMode=value

      if keyname == "initialHeapSize":
        initialHeapSize=value

      if keyname == "maxHeapSize":
        maxHeapSize=value

      if keyname == "managerProfileName":
        managerProfileName=value
		
      if keyname == "CustomNodeNameList":
        customNodeNameList=value
	
     	      	
except Exception, e:
    printMessage("Exception occurred while storing properties into variables...", e)    
    System.exit(1)       	

if initialHeapSize=="":
  initialHeapSize="256"

if maxHeapSize=="":
  maxHeapSize="512"

validateInput()
  
#------------------------------------------------------------------------------------------------
#				       
#Cluster and cluster members creation. 
#				       
#------------------------------------------------------------------------------------------------

# Creating cluster with the input clusterName
try:
    AdminTask.createCluster("[-clusterConfig [-clusterName "+clusterName+"] -replicationDomain [-createDomain true]]")
    loggingjy.info("Cluster Created......")
except Exception, e:
    printErrorMessage("Exception occurred while creating cluster named:["+clusterName+"]...", e)
    System.exit(1)

# Creating and populating a datastructure where a map will keep nodeName as key and list of servers as value
nodeAndServersMap = HashMap()

serverHostNames = ManagedServersListenAddressList.split(",")
serverNames = ManagedServersList.split(",")
customNodeNames=customNodeNameList.split(",")
counter=0
for serverHostName in serverHostNames:
   customNodeName = customNodeNames[counter]
   serverList = nodeAndServersMap.get(customNodeName)
   if(serverList is None):
      serverList = ArrayList()
      nodeAndServersMap.put(customNodeName, serverList)
   serverList.add(serverNames[counter])   
   counter = counter+1


try:
    loggingjy.info("Creating cluster members...")
    # Creating first cluster member
    AdminTask.createClusterMember("[-clusterName "+clusterName+" -memberConfig [-memberNode "+customNodeNames[0]+" -memberName "+serverNames[0]+" -memberWeight 2 -replicatorEntry true] -firstMember [-templateName default -nodeGroup DefaultNodeGroup -coreGroup DefaultCoreGroup]]")
    loggingjy.info("First cluster member created...")
    # Creating rest members
    entrySet = nodeAndServersMap.entrySet()
    entrySetIterator = entrySet.iterator()
    while(entrySetIterator.hasNext()):
       entry = entrySetIterator.next()
       nodeValue = entry.getKey()
       tempServerList = entry.getValue()
       i = 0
       while(i < tempServerList.size()):
            memberName =  tempServerList.get(i)
            if(memberName != serverNames[0]):
               loggingjy.info("Creating cluster member "+memberName+"...")
               AdminTask.createClusterMember("[-clusterName "+clusterName+" -memberConfig [-memberNode "+nodeValue+" -memberName "+memberName+" -memberWeight 2]]")
            i=i+1
except Exception, e:
    printErrorMessage("Exception occurred while creating Cluster members...", e)    
    System.exit(1)

for sName in serverNames:
    changeHeapSizeOfServer(sName, initialHeapSize, maxHeapSize)
    changeCookiePath(sName)

#------------------------------------------------------------------------------------------------
#				    
# Setting up secuirty configuration 
#				   
#------------------------------------------------------------------------------------------------

try:
    security=AdminConfig.getid("/Cell:"+cellName+"/Security:/")
except Exception, e:
   printErrorMessage("Exception occurred while accessing security on cell:["+cellName+"].", e)   
   System.exit(1)

# Setting up J2C Alias Configuration
try:
    #AdminConfig.required('JAASAuthData')
    alias = ['alias', "J2CDBAlias_EAI_"+clusterName]
    userid = ['userId', dbOnlineUserId]
    password = ['password', dbOnlinePassword]
    jaasAttrs = [alias, userid, password]
    AdminConfig.create('JAASAuthData', security, jaasAttrs)    
    loggingjy.info("J2C Alias Created...")
except Exception, e:
    printErrorMessage("Exception occurred while creating J2C Alias configuration with name :[J2CDBAlias"+clusterName+"].", e)    
    System.exit(1)    

#------------------------------------------------------------------------------------------------
# JAAS Application Modules  configuration 
#------------------------------------------------------------------------------------------------
try:
# Locate Application Login Config
    slc = AdminConfig.showAttribute(security, "applicationLoginConfig")
except Exception, e:
    printErrorMessage("Exception occurred while locating Application Login Config.", e)    
    System.exit(1)    

#------------------------------------------------------------------------------------------------
#                          
# JDBC Configuration       
#                           
#------------------------------------------------------------------------------------------------

if(dbType=="O" or dbType =="o"):
    configureJDBCForOracle()
else:
    configureJDBCForDB2()

# Connection Pool Settings
changeMaxConnectionPool(clusterName)


#------------------------------------------------------------------------------------------------
# Creation of Virtual Host and modification of various ports 
#------------------------------------------------------------------------------------------------

# Creating Data Structure for storing server and port values specified in property file

try:
    managedServerNames = ManagedServersList.split(",")    
    bootstrapportNumbers = bootstrapPortList.split(",")
    defaultHostPortNumbers = defaultHostList.split(",")
    defaultHostSSLPortNumbers = defaultHostSSLList.split(",")
    soapPortNumbers = soapPortList.split(",")
    sasSSLlistenPortNumbers = sasSSLlistenPortList.split(",")
    csivSSLSrvrListenPortNumbers = csivSSLSrvrListenPortList.split(",")
    csivSSLMultListenPortNumbers = csivSSLMultListenPortList.split(",")
    adminHostPortNumbers = adminHostList.split(",")
    unicastPortNumbers = unicastPortList.split(",")
    adminHostSSLPortNumbers = adminHostSSLList.split(",")
    sipDefaultHostPortNumbers = sipDefaultHostList.split(",")
    sipDefaultHostSecurePortNumbers = sipDefaultHostSecureList.split(",")
    sipEndPointPortNumbers = sipEndPointPortList.split(",")
    sipEndPointSecurePortNumbers = sipEndPointPortSecureList.split(",")
    #sipMQPortNumbers = sipMQPortList.split(",")
    #sipMQSecurePortNumbers = sipMQportSecureList.split(",")
    orbListenPortNumbers = orbListenPortList.split(",")
    i = 0
    for managedServerName in managedServerNames:
        portNameAndPortNumberMap = serverAndPortsMap.get(managedServerName)
        if(portNameAndPortNumberMap is None):
           portNameAndPortNumberMap = HashMap()
           serverAndPortsMap.put(managedServerName, portNameAndPortNumberMap)
        portNameAndPortNumberMap.put("BOOTSTRAP_ADDRESS", bootstrapportNumbers[i])
        portNameAndPortNumberMap.put("WC_defaulthost", defaultHostPortNumbers[i])
        portNameAndPortNumberMap.put("WC_defaulthost_secure", defaultHostSSLPortNumbers[i])
        if(soapPortList !=""):         
            portNameAndPortNumberMap.put("SOAP_CONNECTOR_ADDRESS", soapPortNumbers[i])
        if(sasSSLlistenPortList !=""):         
            portNameAndPortNumberMap.put("SAS_SSL_SERVERAUTH_LISTENER_ADDRESS", sasSSLlistenPortNumbers[i])
        if(csivSSLSrvrListenPortList !=""):         
            portNameAndPortNumberMap.put("CSIV2_SSL_SERVERAUTH_LISTENER_ADDRESS", csivSSLSrvrListenPortNumbers[i])
        if(csivSSLMultListenPortList !=""):         
            portNameAndPortNumberMap.put("CSIV2_SSL_MUTUALAUTH_LISTENER_ADDRESS", csivSSLMultListenPortNumbers[i])
        if(adminHostList !=""):         
            portNameAndPortNumberMap.put("WC_adminhost", adminHostPortNumbers[i])        
        if(unicastPortList !=""):         
            portNameAndPortNumberMap.put("DCS_UNICAST_ADDRESS", unicastPortNumbers[i])
        if(adminHostSSLList !=""):         
            portNameAndPortNumberMap.put("WC_adminhost_secure", adminHostSSLPortNumbers[i])        
        if(sipDefaultHostList !=""):         
            portNameAndPortNumberMap.put("SIP_DEFAULTHOST", sipDefaultHostPortNumbers[i])
        if(sipDefaultHostSecureList !=""):         
            portNameAndPortNumberMap.put("SIP_DEFAULTHOST_SECURE", sipDefaultHostSecurePortNumbers[i])
        if(sipEndPointPortList !=""):         
            portNameAndPortNumberMap.put("SIB_ENDPOINT_ADDRESS", sipEndPointPortNumbers[i])
        if(sipEndPointPortSecureList !=""):         
            portNameAndPortNumberMap.put("SIB_ENDPOINT_SECURE_ADDRESS", sipEndPointSecurePortNumbers[i])
        if(orbListenPortList !=""):         
            portNameAndPortNumberMap.put("ORB_LISTENER_ADDRESS", orbListenPortNumbers[i])
        i = i + 1
       
except Exception, e:
    printErrorMessage("Exception occurred while mapping server(s) to ports. Please verify the ports list..", e)
    System.exit(1)
    
# Fetching the Servers' default-host port and default-host-secure ports 

try:  
    
	for nodeName in customNodeNames:
            node = AdminConfig.getid("/Node:"+nodeName+"/")
	    serverEntries = AdminConfig.list('ServerEntry', node).split(java.lang.System.getProperty('line.separator'))
	    for serverEntry in serverEntries:
		  sName = AdminConfig.showAttribute(serverEntry, "serverName")
		  managedServersListStr = String(ManagedServersList)
		  if(managedServersListStr.indexOf(sName) != -1):
			 oldServerPortsMap = oldServerPortNamesAndNumbersMap.get(sName)
			 if(oldServerPortsMap is None):
				oldServerPortsMap = HashMap()
				oldServerPortNamesAndNumbersMap.put(sName, oldServerPortsMap)
			 temp = AdminConfig.showAttribute(serverEntry, "specialEndpoints")
 			 specialEndPoints = temp.split(" ")
			 for tmp in specialEndPoints:
			   specialEndPoint = tmp.replace("[", "")
			   specialEndPoint = specialEndPoint.replace("]", "")
			   endPointNm = AdminConfig.showAttribute(specialEndPoint, "endPointName")
			   if endPointNm == "WC_defaulthost":
				  ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
				  portValue = AdminConfig.show(ePoint, 'port')
				  portValue = portValue.replace("[port ", "")
				  defaultPort = portValue.replace("]", "")
				  oldServerPortsMap.put("WC_defaulthost", defaultPort)
			
			   if endPointNm == "WC_defaulthost_secure":
				  ePoint = AdminConfig.showAttribute(specialEndPoint, "endPoint")
				  portValue = AdminConfig.show(ePoint, 'port')
				  portValue = portValue.replace("[port ", "")
				  defaultPortSSL = portValue.replace("]", "")
				  oldServerPortsMap.put("WC_defaulthost_secure", defaultPortSSL)
except Exception, e:
    printErrorMessage("Exception occurred while fetching the Server's default-host port and default-host-secure ports ...", e)
    System.exit(1)
 
# --- Creating Virtual Host and its aliases

try:
    cell = AdminConfig.getid("/Cell:"+cellName+"/")
    vtempl = AdminConfig.listTemplates('VirtualHost', 'default_host')
    vHostName = clusterName+"_Host"
    vth=AdminConfig.createUsingTemplate('VirtualHost', cell, [['name', vHostName]], vtempl)
    entrySet = oldServerPortNamesAndNumbersMap.entrySet()
    entrySetIterator = entrySet.iterator()
    while(entrySetIterator.hasNext()):
       entry = entrySetIterator.next()       
       sName = entry.getKey()
       portNamesAndNumbersMap = oldServerPortNamesAndNumbersMap.get(sName)  
       if(portNamesAndNumbersMap is not None):
          defaultPort = portNamesAndNumbersMap.get("WC_defaulthost")
          defaultPortSSL = portNamesAndNumbersMap.get("WC_defaulthost_secure")
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

#-------------------------------------------------------------------------------------------------------------------------
# Modifying the specified port numbers of the server(s) and virtual host 
#-------------------------------------------------------------------------------------------------------------------------

try:
     for nodeName in customNodeNames:
       modifyPorts(cellName, nodeName)
except Exception, e:
    printErrorMessage("Exception occurred while modifying ports ...", e)
    System.exit(1)

AdminConfig.save()
loggingjy.info("All configurations have been done successfully...")
print "All configurations have been done successfully..."

