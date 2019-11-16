from java.util import Properties
from java.io import FileInputStream
from java.io import File

def validateIn():
	########################################################
	#                                                      #
	# LOADING properties from was.config.properties file...#
	#                                                      #
	########################################################

	myProps = Properties()
	try:
	    myProps.load(FileInputStream(File('app.config.properties')))
	    propertyNames = myProps.propertyNames()
	except Exception, e:
	    printErrorMessage("Error occurred while loading properties file['app.config.properties']...", e)
	    System.exit(1)

	#####################################################
	#                                                   #
	#   STORING PROPERTY VALUES IN VARIABLES....        #
	#                                                   #
	#####################################################
	try:
	    while propertyNames.hasMoreElements():
	      keyname = str(propertyNames.nextElement())
	      value = myProps.getProperty(keyname)

	      if keyname == "cellName":
	        cellName=value

	      if keyname == "standAloneServerName":
	        standAloneServerName=value

	      if keyname == "inputjdbcproviderName":
	        inputjdbcproviderName=value
			
	      if keyname == "dbJndiName":
	        dbJndiName=value

	      if keyname == "dbName":
	        dbName=value

	      if keyname == "dbusr":
	        dbusr=value
			
	      if keyname == "DBMSMode":
	        DBMSMode=value

	      if keyname == "dbDriverJarPath":
	        dbDriverJarPath=value

	      if keyname == "dbAddr":
	        dbAddr=value
			
	      if keyname == "dbPort":
	        dbPort=value
			
	      if keyname == "dbSchemaName":
	        dbSchemaName=value

	      if keyname == "appHome":
	        appHome=value

	      if keyname == "archiveFileName":
	        archiveFileName=value

	      if keyname == "appName":
	        appName=value
			
	      if keyname == "initialHeapSize":
	        initialHeapSize=value

	      if keyname == "maxHeapSize":
	        maxHeapSize=value
			
	      if keyname == "jvmArgs":
	        jvmArgs=value

	except Exception, e:
	    printErrorMessage("Exception occurred while storing properties into variables...", e)
	    System.exit(1)

	print('Validation Successful')
