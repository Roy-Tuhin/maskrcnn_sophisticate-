standAloneServerName="server1"
cellName="InBlrQz17Node06Cell"
standAloneNodeName="InBlrQz17Node06"
print('hiii')
#try:
    #server=AdminConfig.getid("/Server:"+standAloneServerName+"/")
    #serverStr=AdminConfig.getObjectName(server)
    #print "serverStr: "+serverStr
    #if serverStr == "":
       #AdminControl.invoke("WebSphere:name=NodeAgent,process=nodeagent,platform=common,node="+standAloneNodeName+",diagnosticProvider=true,version=6.1.0.2,type=NodeAgent,mbeanIdentifier=NodeAgent,cell="+cellName+",spec=1.0", "launchProcess", "["+standAloneServerName+"]", "[java.lang.String]")
    #else:
       #print "Stopped Server : "+standAloneServerName
#except Exception,e:
    #printErrorMessage("Exception occurred while starting server:"+ standAloneServerName,e)
    #System.exit(1)

