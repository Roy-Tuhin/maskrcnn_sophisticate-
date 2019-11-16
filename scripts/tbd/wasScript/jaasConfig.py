#####################################
#                                   #
# Setting up secuirty configuration #
#                                   #
#####################################
cellName="InBlrQz17Node06Cell"
standAloneManagedServer="server1"

try:
    security=AdminConfig.getid("/Cell:"+cellName+"/Security:/")
except Exception, e:
    printErrorMessage("Exception occurred while accessing security on cell:["+cellName+"].", e)
    System.exit(1)
	
##################### JAAS Application Modules configuration ###################
# Locate Application Login Config
try:
    slc = AdminConfig.showAttribute(security, "applicationLoginConfig")
    print(slc)
    AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while locating Application Login Config.", e)
    System.exit(1)
print("All configurations done successfully.. ")
