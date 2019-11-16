appHome="/home/was6/profiles/HUBDev/MSApp/SAML/SAML"
archiveFileName="PostSAMLAccRegisterEAR.ear"
appName="SAML"
#standAloneServerName="server1"

try:
	AdminApp.install(appHome+"/"+archiveFileName, "[ -nopreCompileJSPs -distributeApp -nouseMetaDataFromBinary -nodeployejb -appname "+appName+" -createMBeansForResources -noreloadEnabled -nodeployws -validateinstall warn -noprocessEmbeddedConfig -filepermission .*\.dll=755#.*\.so=755#.*\.a=755#.*\.sl=755 -noallowDispatchRemoteInclude -noallowServiceRemoteInclude]" ) 
	AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while installing application..", e)
    System.exit(1)
