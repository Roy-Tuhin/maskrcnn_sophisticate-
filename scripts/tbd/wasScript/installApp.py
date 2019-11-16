appHome="/home/was6/BhaskarM/WASAdmin/HUB_MS360/MS360"
archiveFileName="BancsEAR.ear"
appName="BancsMS360"
standAloneServerName="server1"
cellName="InBlrQz17Node06Cell"
standAloneNodeName="InBlrQz17Node06"

try:
	AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -installed.ear.destination "+appHome+"/data -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -target WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -processEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -MapWebModToVH [['BancsWEB.war' BancsWEB.war,WEB-INF/web.xml default_host]] -MapWebModToVH [['MS360' MS360.war,WEB-INF/web.xml default_host]] -MapWebModToVH [['MS360_MM' MS360_MM.war,WEB-INF/web.xml default_host]] -noallowServiceRemoteInclude [-MapModulesToServers [['BancsEJB.jar' BancsEJB.jar,META-INF/ejb-jar.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUBMS360Appn' BancsWEB.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUBMS360Appn' MS360.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"] ['HUBMS360Appn' MS360_MM.war,WEB-INF/web.xml WebSphere:cell="+cellName+",node="+standAloneNodeName+",server="+standAloneServerName+"]]]]")
	AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while installing application..", e)
    System.exit(1)
