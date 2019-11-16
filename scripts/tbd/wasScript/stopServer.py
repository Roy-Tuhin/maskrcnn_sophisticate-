appHome="/home/was6/BhaskarM/WASAdmin/HUB_MS360/MS360"
archiveFileName="BancsEAR.ear"
appName="BancsMS360"
standAloneServerName="server1"
cellName="InBlrQz17Node06Cell"
standAloneNodeName="InBlrQz17Node06"

try:
    server=AdminConfig.getid("/Server:"+standAloneServerName+"/")
    serverStr=AdminConfig.getObjectName(server)
    if serverStr == "":
       print "Server already stopped"
    else:
       AdminControl.invoke(serverStr, "stop")
       print "Stopped Server : "+standAloneServerName
except Exception,e:
    printErrorMessage("Exception occurred while stopping server:"+ standAloneServerName,e)
    System.exit(1)
