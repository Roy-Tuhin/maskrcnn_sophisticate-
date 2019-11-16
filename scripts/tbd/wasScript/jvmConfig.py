# Server JVM Heap size properties
initialHeapSize="512"
maxHeapSize="1024"
jvmArgs="-XX:MaxPermSize=1024m -XX:MaxNewSize=512m -XX:NewSize=512m -Xss1024k"
standAloneNodeName="InBlrQz17Node06"
standAloneManagedServer="server1"


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
        AdminConfig.modify(jvmEntries, [['initialHeapSize', java.lang.Integer(initialHeapSize).intValue()], ['maximumHeapSize',
java.lang.Integer(maxHeapSize).intValue()],['genericJvmArguments',jvmArgs]])
	AdminConfig.save()
   except Exception, e:
    printErrorMessage("Exception occurred while changing heap size of server "+serverName +" ...", e)
    System.exit(1)
changeHeapSizeOfServer(standAloneManagedServer,initialHeapSize,maxHeapSize,jvmArgs)
print("All configurations done successfully.. ")
