appHome="/home/was6/profiles/HUBDev/MSApp/MMClientServEJB/Channels"
archiveFileName="MSEJB.ear"
appName="msejb"
#standAloneServerName="server1"
#cellName="InBlrQz17Node06Cell"
#standAloneNodeName="InBlrQz17Node06"

try:
	#AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -installed.ear.destination "+appHome+"/data -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude [-MapModulesToServers [['msejb.jar' msejb.jar,META-INF/ejb-jar.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"]]]]")
	AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude]" ) 
	AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while installing application..", e)
    System.exit(1)
