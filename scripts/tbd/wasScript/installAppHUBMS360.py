appHome="/home/was6/profiles/HUBDev/MSApp/HUBMS360/MS360"
archiveFileName="BancsEAR.ear"
appName="BancsEAR"
#standAloneServerName="server1"
#cellName="InBlrQz17Node06Cell"
#standAloneNodeName="InBlrQz17Node06"

try:
	#AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -MapWebModToVH [['BancsWEB.war' BancsWEB.war,WEB-INF/web.xml default_host]] -MapWebModToVH [['MS360' MS360.war,WEB-INF/web.xml default_host]] -MapWebModToVH [['MS360_MM' MS360_MM.war,WEB-INF/web.xml default_host]] -noallowServiceRemoteInclude [ -MapModulesToServers [['BancsEJB.jar' BancsEJB.jar,META-INF/ejb-jar.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUBMS360Appn' BancsWEB.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUBMS360Appn' MS360.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUBMS360Appn' MS360_MM.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"]]] -CtxRootForWebMod [[ MS360_MM MS360_MM.war,WEB-INF/web.xml /MMInternal ]]]")
	AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude]" )
	AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while installing application..", e)
    System.exit(1)
