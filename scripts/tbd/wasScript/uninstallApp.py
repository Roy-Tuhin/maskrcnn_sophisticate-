appName="BancsMS360"
#appName="BancsMS360"
standAloneServerName="server1"

try:
    AdminApp.uninstall(appName)
    AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while uninstalling application..."+appName, e)
    System.exit(1)
