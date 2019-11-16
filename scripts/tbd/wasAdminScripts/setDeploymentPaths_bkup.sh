#!/bin/bash
appHome="/home/was6/BancsAppHome"

bootstrapPort=`grep bootstrapPortList was.ports.properties | cut -f2 -d'='`
echo $bootstrapPort
ipaddress=`/sbin/ifconfig -a | grep inet | grep -v '127.0.0.1' |awk '{ print $2}'| cut -f2 -d':'`
echo $ipaddress

changeto="\<PROVIDER_URL\>iiop:\\/\\/$ipaddress:$bootstrapPort"
echo $changeto
sed 's/'\<PROVIDER_URL\>iiop:\\/\\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*'/'"$changeto"'/g' $appHome/properties/Deployment/XMLFiles/configHelper.xml > $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml 

changeJMSto="\<JMS_PROVIDER_URL\>iiop:\\/\\/$ipaddress:$bootstrapPort"
echo $changeJMSto
sed 's/'\<JMS_PROVIDER_URL\>iiop:\\/\\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*'/'"$changeJMSto"'/g' $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml > $appHome/properties/Deployment/XMLFiles/configHelper_mod2.xml 

rm  $appHome/properties/Deployment/XMLFiles/configHelper.xml
rm  $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml
mv  $appHome/properties/Deployment/XMLFiles/configHelper_mod2.xml  $appHome/properties/Deployment/XMLFiles/configHelper.xml


#chglineProviderURL=`grep "<PROVIDER_URL" $appHome/properties/Deployment/XMLFiles/configHelper.xml`
#cp -i $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml $appHome/properties/Deployment/XMLFiles/configHelper.xml
#`sed -n' and `s/regex/replace/p'
#sed 's/'\<PROVIDER_URL\>iiop:\\/\\/172.19.98.15:2809'/'$changeto'/g' configHelper.xml > configHelper_mod.xml
#sed -n '/'\<PROVIDER_URL\>iiop:\\/\\/[0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*'/!p' configHelper.xml > configHelper_mod.xml 
#sed -n '/'\<PROVIDER_URL\>iiop:\\/\\/'/{g;8!p;};h' configHelper.xml > configHelper_mod.xml 
#sed -n '10q;9p' configHelper.xml
# print the line immediately before a regexp, but not the line
 # containing the regexp
# sed -n '/regexp/{g;1!p;};h'
#sed -n '/regexp/p'
#sed 's/PROVIDER_URL/'qwert'/g' configHelper.xml > configHelper_mod.xml
#cp -i $appHome/properties/Deployment/XMLFiles/configHelper_mod.xml $appHome/properties/Deployment/XMLFiles/configHelper.xml
