import os 
from java.util import Properties
from java.io import FileInputStream
from java.io import File
import validateInput

standAloneNodeName="InBlrQz17Node06"
standAloneManagedServer="server1"
DBMSMode="S"
dbJndiName = "jdbc/MMDataSource";
dbName="MSDEV"
dbAddressString="172.19.98.148:50001"
dbDriverJarPath="/home/was6/db2jars"
dbusr="db2dev_usr"
dbSchemaName="PAYPERF"

#------------------------------------------------------------------------------
#  Method for configuring JDBC Providers and DataSources for DB2
#----------------------------------------------------------------------------

#validateInput.validateIn()
#myProps = Properties()
#  try:
#    myProps.load(FileInputStream(File('app.config.properties')))
#    propertyNames = myProps.propertyNames()
#  except Exception, e:
#    printErrorMessage("Error occurred while loading properties file['app.config.properties']...", e)
#    System.exit(1)

#os.system('python validateInput.py')

def configureJDBCForDB2():
  # XA JDBC Provider name
  jdbcProviderName="DB2 Universal JDBC Driver Provider"
  dbAliasName="MMDataSource_XA"
  dbAliasName2 = "RTA_XA"
  try:
    # Creating XA JDBC Provider
    DataSource=AdminTask.createJDBCProvider("[-scope Node="+standAloneNodeName+",Server="+standAloneManagedServer+" -databaseType DB2 -providerType '"+jdbcProviderName+"' -implementationType 'XA data source' -name 'DB2 Universal JDBC Driver Provider (XA)' -description 'XA DB2 Universal JDBC Driver-compliant Provider' -classpath "+dbDriverJarPath+"/db2jcc.jar;"+dbDriverJarPath+"/db2jcc_license_cu.jar;"+dbDriverJarPath+"/db2jcc_license_cisuz.jar -nativePath ${DB2UNIVERSAL_JDBC_DRIVER_NATIVEPATH} ]")
  except Exception, e:
    printErrorMessage("Exception occurred while creating JDBC Providers..", e)
    System.exit(1)

configureJDBCForDB2()
AdminConfig.save()
print("All configurations done successfully.. ")
