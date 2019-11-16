#!/bin/bash
#appHome=`echo $appHome`
#appHome="/home/was6/BancsAppHome

loop=1
while [ $loop -lt 4 ]
do
	  echo "Enter the properties Folder Path:"
          read appHome
          if [ -z "$appHome" ]
          then
            echo "properties folder path is not set. Please try again."
            loop=`expr $loop + 1`
           else
	      if [ ! -d $appHome/properties/Deployment ]
	      then
    		      echo "properties directory doesn't exists"
		      loop=`expr $loop + 1`			
	      else
		      break
	      fi
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
done

WebServerName=172.19.98.15
WebServerPort=9080

bootstrapPort=`grep bootstrapPortList was.ports.properties | cut -f2 -d'='`
echo $bootstrapPort
ipaddress=`/sbin/ifconfig -a | grep inet | grep -v '127.0.0.1' |awk '{ print $2}'| cut -f2 -d':'`
echo $ipaddress

WebServerName=$ipaddress
WebServerPort=`grep defaultHostList was.ports.properties | cut -f2 -d'='`
#EjbContextURL=
#BindPropFile="$appHome\\/Deployment\\/InputFiles\\/BindPropFile.xml"

changeto="\<PROVIDER_URL\>iiop:\\/\\/$ipaddress:$bootstrapPort"
echo $changeto
sed 's/'\<PROVIDER_URL\>iiop:\\/\\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*'/'"$changeto"'/g' $appHome/properties/Deployment/XMLFiles/configHelper.xml > $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml 

changeJMSto="\<JMS_PROVIDER_URL\>iiop:\\/\\/$ipaddress:$bootstrapPort"
echo $changeJMSto
sed 's/'\<JMS_PROVIDER_URL\>iiop:\\/\\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*'/'"$changeJMSto"'/g' $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml > $appHome/properties/Deployment/XMLFiles/configHelper_mod2.xml 

rm  $appHome/properties/Deployment/XMLFiles/configHelper.xml
rm  $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml
mv  $appHome/properties/Deployment/XMLFiles/configHelper_mod2.xml  $appHome/properties/Deployment/XMLFiles/configHelper.xml

chWebServerName="WebServerName\=$WebServerName"
chWebServerPort="WebServerPort\=$WebServerPort"
chEJBCONTEXTURL="EJBCONTEXTURL\=iiop:\\/\\/$ipaddress:$bootstrapPort"

sed 's/'WebServerPort\=[0-9]*'/'$chWebServerPort'/g' $appHome/properties/Deployment/InputFiles/war_properties > $appHome/properties/Deployment/InputFiles/war_properties_mod1

sed 's/'WebServerName\=[0-9]*.[0-9]*.[0-9]*.[0-9]*'/'$chWebServerName'/g' $appHome/properties/Deployment/InputFiles/war_properties_mod1 > $appHome/properties/Deployment/InputFiles/war_properties_mod2

sed 's/'EJBCONTEXTURL\=iiop:\\/\\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*'/'"$chEJBCONTEXTURL"'/g' $appHome/properties/Deployment/InputFiles/war_properties_mod2 > $appHome/properties/Deployment/InputFiles/war_properties_mod3 

rm  $appHome/properties/Deployment/InputFiles/war_properties
rm  $appHome/properties/Deployment/InputFiles/war_properties_mod1
rm  $appHome/properties/Deployment/InputFiles/war_properties_mod2
mv  $appHome/properties/Deployment/InputFiles/war_properties_mod3 $appHome/properties/Deployment/InputFiles/war_properties

chBindPropFile="BindPropFile=$appHome/properties/Deployment/InputFiles/BindPropFile.xml"
echo $chBindPropFile
sed -n '/'BindPropFile'/!p' $appHome/properties/Deployment/InputFiles/war_properties > $appHome/properties/Deployment/InputFiles/war_properties_mod1

echo $chBindPropFile >> $appHome/properties/Deployment/InputFiles/war_properties_mod1
mv  $appHome/properties/Deployment/InputFiles/war_properties_mod1 $appHome/properties/Deployment/InputFiles/war_properties

chFile="log4j.appender.R.File=$appHome/properties/Deployment/logs/Logthis.log"
echo $chFile
sed -n '/'Logthis'/!p' $appHome/properties/Deployment/InputFiles/commons-logging.properties > $appHome/properties/Deployment/InputFiles/commons-logging_mod.properties
echo $chFile >> $appHome/properties/Deployment/InputFiles/commons-logging_mod.properties
mv  $appHome/properties/Deployment/InputFiles/commons-logging_mod.properties $appHome/properties/Deployment/InputFiles/commons-logging.properties


