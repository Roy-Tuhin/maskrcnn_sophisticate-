
wasRoot=`cat was.config.properties| grep wasRoot | cut -f2 -d'='`
if [ -z "$wasRoot" ]
then
  echo "Websphere Application Server root directory is blank"
  exit -1
else
  echo "Websphere Root is $wasRoot"
fi

customProfileName=`cat was.config.properties| grep customProfileName | cut -f2 -d'='`
if [ -z "$customProfileName" ]
then
  echo "Custom profile name is blank"
  exit -1
else
  echo "Custom profile name is $customProfileName"
fi

echo "Stopping server"
sh $wasRoot/profiles/$customProfileName/bin/wsadmin.sh -lang jython -f stopServer.py 


