appHome="/home/was6/profiles/HUBDev/MSApp/MMClientServ/Channels"
archiveFileName="MoneyMovement.war"
appName="MoneyMovement_war"
#standAloneServerName="server1"
#cellName="InBlrQz17Node06Cell"
#standAloneNodeName="InBlrQz17Node06"

try:
        #AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -installed.ear.destination "+appHome+"/data -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude -MapWebModToVH [['Money Movement Application' "+archiveFileName+",WEB-INF/web.xml default_host]] -MapModulesToServers [['Money Movement Application' "+archiveFileName+",WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"]] -contextroot /MoneyMovement ]")
	AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude -contextroot /MoneyMovement ]" ) 
	AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while installing application..", e)
    System.exit(1)
