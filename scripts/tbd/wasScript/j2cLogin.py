#####################################
#                                   #
# Setting up secuirty configuration #
#                                   #
#####################################
cellName="InBlrQz17Node06Cell"
standAloneManagedServer="server1"
aliasName="db2dev_usr"
dbOnlineUserId="db2dev"
dbOnlinePassword="DB2@2009"
try:
    security=AdminConfig.getid("/Cell:"+cellName+"/Security:/")
except Exception, e:
    printErrorMessage("Exception occurred while accessing security on cell:["+cellName+"].", e)
    System.exit(1)
# Setting up J2C Alias Configuration
try:
    AdminConfig.required('JAASAuthData')
    alias = ['alias', aliasName]
    userid = ['userId', dbOnlineUserId]
    password = ['password', dbOnlinePassword]
    jaasAttrs = [alias, userid, password]
    AdminConfig.create('JAASAuthData', security, jaasAttrs)
    AdminConfig.save()
except Exception, e:
    printErrorMessage("Exception occurred while creating J2C Alias configuration with name :"+aliasName, e)
    System.exit(1)
print("All configurations done successfully.. ")
