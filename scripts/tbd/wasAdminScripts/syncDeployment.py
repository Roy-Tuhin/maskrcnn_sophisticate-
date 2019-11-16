import loggingjy
import sys
from java.lang import System
from java.lang import Exception
from java.util import Properties
from java.io import FileInputStream
from java.io import File
from java.util import HashMap

########################################
# INITIALIZING STRING VARIABLES .....  #
########################################

# WebSphere Application Server spcific properties
wasNDVersion=""
wasRoot=""
# Application Server configuration specific properties
cellName=""
standAloneNodeName=""
standAloneManagedServer=""
customProfileName=""
managerProfileName=""
clusterName=""
customNodeNameList=""
appDepMode=""

hostname=sys.argv[0]
logDir=sys.argv[1]

#--------------------------------------------------------------
# Initializing Logger
#--------------------------------------------------------------

loggingjy.basicConfig(level=loggingjy.DEBUG,format='%(asctime)s %(levelname)-8s %(message)s',datefmt='%a, %d %b %Y %H:%M:%S',filename=logDir+'log/syncDeployment.log',filemode='a')

loggingjy.info("Synchronization of deployment process starting.It will take a few minutes..")

#--------------------------------------------------------------
# Property Validation Method
#--------------------------------------------------------------
def validateInput():
  valid="true"
  # WebSphere Application server specific validations
  if(wasNDVersion == ""):
       loggingjy.error("wasNDVersion can't be blank")
       valid="false"
  else:
       if(wasNDVersion == "Y" or wasNDVersion =="y" or wasNDVersion =="N" or wasNDVersion =="n"):
            loggingjy.info("wasNDVersion? "+wasNDVersion)
       else:
            loggingjy.error("wasNDVersion is not valid. Entered value is: "+wasNDVersion)
            valid="false"

  if(appDepMode == ""):
       loggingjy.error("appDepMode can't be blank")
       valid="false"
  else:
       if(appDepMode == "C" or appDepMode =="c" or appDepMode =="S" or appDepMode =="s"):
            loggingjy.info("appDepMode is "+appDepMode)
       else:
            loggingjy.error("appDepMode is not valid. Entered value is: "+appDepMode)
            valid="false"
  if(wasRoot == ""):
    loggingjy.error("wasRoot cannot be blank..")
    valid="false"
  else:
      if ((appDepMode =="s" or appDepMode == "S" ) and File(wasRoot+"/profiles/"+customProfileName).canWrite()!=1):
        loggingjy.error(" : " + wasRoot+"/profiles/"+customProfileName+" dosen't exist or is not writable.")
        valid="false"
      elif((appDepMode =="c" or appDepMode == "C" ) and File(wasRoot+"/profiles/"+managerProfileName).canWrite()!=1):
         loggingjy.error(" : " + wasRoot+"/profiles/"+managerProfileName+" dosen't exist or is not writable.")
         valid="false"
  #Profiles related properties validations  
  if(cellName == ""):
    loggingjy.error("cellName can't be blank.")
    valid="false"
	
  if((appDepMode =="s" or appDepMode == "S" ) and customProfileName == ""):
    loggingjy.error("customProfileName can't be blank.")
    valid="false"
	
  if((appDepMode =="s" or appDepMode == "S" ) and standAloneNodeName == ""):
    loggingjy.error("customNodeName is blank, so using combination of cusomtProfileName_hostName.Make sure that the custom profile's node was created using the same combination.")

  if((appDepMode =="s" or appDepMode == "S" ) and standAloneManagedServer == ""):
    loggingjy.error("standAloneManagedServer can't be blank.")
    valid="false"

  if((appDepMode =="c" or appDepMode == "C" ) and managerProfileName == ""):
    loggingjy.error("ManagerProfileName can't be blank.")
    valid="false"
 
  if((appDepMode =="c" or appDepMode == "C" ) and clusterName == ""):
    loggingjy.error("clusterName can't be blank.")
    valid="false"
 
  if((appDepMode =="c" or appDepMode == "C" ) and customNodeNameList == ""):
    loggingjy.error("customNodeNameList can't be blank.")
    valid="false"

  if(valid=="false"):
    print "Error : Input Validation Failed Check syncDeployment.log in log directory for more detials"
    print "Exiting...."
    System.exit(1) 

#---------------------------------------------------------------------
#  Method to print error message on console and in log file
#---------------------------------------------------------------------

def printErrorMessage(logMessage,exceptionObj):
    print "Error occurred. Check syncDeployment.log in log directory for more details."
    loggingjy.error(logMessage)    
    loggingjy.error(exceptionObj.getMessage())

#####################################################
#						    #	
# LOADING properties from was.config.properties file...#
#						    #	
#####################################################

myProps = Properties()
try:
    myProps.load(FileInputStream(File('was.config.properties')))
    propertyNames = myProps.propertyNames()
except Exception,e:
    printErrorMessage("Error occurred while loading properties file['was.config.properties']...",e)
    System.exit(1)       

#####################################################
#						    #	
#   STORING PROPERTY VALUES IN VARIABLES....        #
#						    #	
#####################################################
try:
    while propertyNames.hasMoreElements():
      keyname = str(propertyNames.nextElement())
      value = myProps.getProperty(keyname)
      if keyname == "wasRoot":
      	wasRoot=value

      if keyname == "wasNDVersion":
        wasNDVersion=value   

      if keyname == "cellName":
      	cellName=value
      	
      if keyname == "customNodeName":
        standAloneNodeName=value

      if keyname == "standAloneManagedServer":
      	standAloneManagedServer=value
		
      if keyname == "customProfileName":
        customProfileName=value	
      
      if keyname == "managerProfileName":
        managerProfileName=value
      
      if keyname == "CustomNodeNameList":
        customNodeNameList=value

      if keyname == "ClusterName":
        clusterName=value

      if keyname == "appDepMode":
        appDepMode=value

		
except Exception,e:	
     printErrorMessage("Exception occurred while storing properties into variables...",e) 	
     System.exit(1)
	
validateInput()

if((appDepMode =="s" or appDepMode == "S" )and standAloneNodeName ==""):
  standAloneNodeName=customProfileName+"_"+hostname

try:
     # Handling if appDepMode is standAlone server
     if((appDepMode =="s" or appDepMode == "S" )):
          #Stopping the Server if in started mode
          print "Stopping the server,if, in STARTED state..."
          serverProcess=AdminControl.completeObjectName("node="+standAloneNodeName+",type=Server,name="+standAloneManagedServer+",*")
          if (serverProcess !=""): 
            serverState=AdminControl.getAttribute(serverProcess,'state')
	    if(serverState =="STARTED"):
               AdminControl.invoke(serverProcess,"stop")
               while(serverProcess !=""):
                   serverProcess=AdminControl.completeObjectName("node="+standAloneNodeName+",type=Server,name="+standAloneManagedServer+",*")
                   java.lang.Thread.sleep(5000)
               loggingjy.info("Server stopped successfully.")
               
          #Synchronizing the repository
          print "Synchronizing the config repository..."
          repositoryProcess = AdminControl.queryNames("type=ConfigRepository,process=nodeagent,cell="+cellName+",node="+standAloneNodeName+",*")
          AdminControl.invoke(repositoryProcess,'refreshRepositoryEpoch')
          loggingjy.info("ConfigRepository refereshed successfully.")
          #Synchornizing the node
          print "Synchronizing the node..."
	  nodeSyncProcess=AdminControl.completeObjectName("type=NodeSync,node="+standAloneNodeName+",*")
	  AdminControl.invoke(nodeSyncProcess, "sync")
          isNodeSynchronized = AdminControl.invoke(nodeSyncProcess,'isNodeSynchronized')
          while(isNodeSynchronized != "true"):
             isNodeSynchronized = AdminControl.invoke(nodeSyncProcess,'isNodeSynchronized')
             java.lang.Thread.sleep(5000)
          loggingjy.info("Node synchronized successfully.")
         #Starting the server
          print "Staring the server..."
          nodeAgentProcess=AdminControl.completeObjectName("node="+standAloneNodeName+",type=NodeAgent,*")
         #print "Node Agent Process is " + nodeAgentProcess
          AdminControl.invoke(nodeAgentProcess,"launchProcess","["+standAloneManagedServer+"]","[java.lang.String]")
          serverProcess=AdminControl.completeObjectName("node="+standAloneNodeName+",type=Server,name="+standAloneManagedServer+",*")
          while(serverProcess ==""):
            serverProcess=AdminControl.completeObjectName("node="+standAloneNodeName+",type=Server,name="+standAloneManagedServer+",*")
            java.lang.Thread.sleep(5000)
          loggingjy.info("Server started successfully.")
     #else if would be cluster case   
     else:
         print "Stopping the cluster, if,in running state..."
         clusterProcess=AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+
",*")
         if (clusterProcess !=""):
             clusterState=AdminControl.getAttribute(clusterProcess,'state')
	     loggingjy.info("Cluster's current state is "+clusterState)
             print "Cluster's current state is "+clusterState
	     if(clusterState != "websphere.cluster.partial.stop"):
                 AdminControl.invoke(clusterProcess, 'stop') 		   
                 while(clusterState !="websphere.cluster.stopped"):
                    clusterProcess=AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+
",*")
                    clusterState=AdminControl.getAttribute(clusterProcess,'state')
		    java.lang.Thread.sleep(5000)
                 loggingjy.info("Cluster ripple started successfully.")

            #Synchronizing the repository
             print "Synchronizing the config repository..."
	     nodeNamesMap = HashMap()
             nodeNames = customNodeNameList.split(",")
	     for nodeName in nodeNames:		  
	        nodeNamesMap.put(nodeName,"") 
	     keySet= nodeNamesMap.keySet()   
	     keySetIterator = keySet.iterator()
	     while(keySetIterator.hasNext()):
                   node=keySetIterator.next()
                   repositoryProcess = AdminControl.queryNames("type=ConfigRepository,process=nodeagent,cell="+cellName+",node="+node+",*")
                   AdminControl.invoke(repositoryProcess,'refreshRepositoryEpoch')
             loggingjy.info("ConfigRepository refereshed successfully for node:"+nodeName)
             #Synchornizing the node
             print "Synchronizing the node..."+nodeName
             nodeSyncProcess=AdminControl.completeObjectName("type=NodeSync,node="+nodeName+",*")
             AdminControl.invoke(nodeSyncProcess, "sync")
             isNodeSynchronized = AdminControl.invoke(nodeSyncProcess,'isNodeSynchronized')
             while(isNodeSynchronized != "true"):
                 isNodeSynchronized = AdminControl.invoke(nodeSyncProcess,'isNodeSynchronized')
                 java.lang.Thread.sleep(5000)
             loggingjy.info("Node '"+nodeName+"' synchronized successfully.")
             #Starting the cluster
	     print "Staring the cluster in ripple start mode..."
	     clusterProcess=AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+
",*")
             AdminControl.invoke(clusterProcess, 'rippleStart') 
             clusterState="" 
             while(clusterState != "websphere.cluster.running"):
                 clusterProcess=AdminControl.completeObjectName("cell="+cellName+",type=Cluster,name="+clusterName+
",*")   
	         if(clusterProcess !=""):
                     clusterState=AdminControl.getAttribute(clusterProcess,'state')
                 java.lang.Thread.sleep(5000)
             loggingjy.info("Cluster "+clusterName+"started successfully.")
         
except Exception,e:	
     printErrorMessage("Exception occurred in the  process Synchronization of deployment ...",e) 
     System.exit(1)

print "Deployment synchronization process completed sucessfully..."	
