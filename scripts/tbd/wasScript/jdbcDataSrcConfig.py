cellName="InBlrQz17Node06Cell"
standAloneNodeName="InBlrQz17Node06"
standAloneServerName="server1"
DBMSMode="S"
dbJndiName = "jdbc/MMDataSource";
dbName="MSDEV"
dbAddressString="172.19.98.148:50003"
dbDriverJarPath="/home/was6/db2jars"
dbusr="db2dev_usr"
dbSchemaName="PAYPERF"
dbAddr="172.19.98.148"
dbPort="50001"
inputjdbcproviderName="DB2 Universal JDBC Driver Provider (XA)"
#inputjdbcproviderName="Derby JDBC Provider (XA)"


#------------------------------------------------------------------------------
#  Method for configuring JDBC Providers and DataSources for DB2
#----------------------------------------------------------------------------

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

def configureDSDB2():
  # XA JDBC Provider name
  try:
    print('hi')	
    server=AdminConfig.getid("/Server:"+standAloneServerName+"/")	
    #print(server)	
    jdbcprovider=AdminConfig.list('JDBCProvider', server)
    print(jdbcprovider)
    jdbcproviderAry=jdbcprovider.split("\n")
    for s_jdbcproviderAry in jdbcproviderAry[:]:
        jdbcproviderAryURL=s_jdbcproviderAry.split("\"")
        print('hii')	
        #print(jdbcproviderAryURL[1])
        jdbcproviderName=jdbcproviderAryURL[1].split("(cells")
        if (jdbcproviderName[0] == inputjdbcproviderName):
            print('hiii')	
            print(jdbcproviderName[0])
            newds = AdminTask.createDatasource(jdbcproviderAryURL[1], '[-name MMDataSource -jndiName '+dbJndiName+' -dataStoreHelperClassName com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper -componentManagedAuthenticationAlias '+dbusr+' -xaRecoveryAuthAlias '+dbusr+' -configureResourceProperties [[databaseName java.lang.String '+dbName+'] [driverType java.lang.Integer 4] [serverName java.lang.String '+dbAddr+'] [portNumber java.lang.Integer '+dbPort+']]]')
    #newds = AdminTask.createDatasource('"DB2 Universal JDBC Driver Provider (XA)(cells/InBlrQz17Node06Cell/nodes/InBlrQz17Node06/servers/server1|resources.xml#JDBCProvider_1272961746244)"', '[-name MMDataSource -jndiName '+dbJndiName+' -dataStoreHelperClassName com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper -componentManagedAuthenticationAlias '+dbusr+' -xaRecoveryAuthAlias '+dbusr+' -configureResourceProperties [[databaseName java.lang.String '+dbName+'] [driverType java.lang.Integer 4] [serverName java.lang.String '+dbAddr+'] [portNumber java.lang.Integer '+dbPort+']]]')
    propSet = AdminConfig.showAttribute(newds, 'propertySet')
    #print(propSet)
    attr = AdminConfig.showAttribute(propSet, 'resourceProperties')
    #print(attr)	
    oldProps = splitProps(attr)
    #print(oldProps)	
    for oldProp in oldProps[:]:
        name = AdminConfig.showAttribute(oldProp, "name")
        if name == "currentSchema":
            AdminConfig.modify(oldProp, [['name', 'currentSchema'], ['value', dbSchemaName]])
  except Exception, e:
    printErrorMessage("Exception occurred while creating JDBC Providers..", e)
    System.exit(1)

configureDSDB2()
AdminConfig.save()
print("All configurations done successfully.. ")
