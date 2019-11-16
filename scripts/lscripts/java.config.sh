#!/bin/bash

##----------------------------------------------------------
### Java Config
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## Change List
##----------------------------------------------------------
## 06-Jul-2018
# 1. JAVA_JDK_VER variable introduced
# 2. JAVA_JDK_VER to be moved to central script: versions.sh
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASHRC_FILE" ]; then
  FILE=$HOME/.bashrc
else
  FILE=$BASHRC_FILE
fi

#JAVA_JDK_VER="1.8.0"
#JAVA_JDK_VER="9"

if [ -z "$JAVA_JDK_VER" ]; then
  JAVA_JDK_VER="8"
fi

LINE='export JAVA_HOME="/usr/lib/jvm/java-'$JAVA_JDK_VER'-openjdk-amd64"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE='export PATH="$PATH:/usr/lib/jvm/java-'$JAVA_JDK_VER'-openjdk-amd64/bin"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE='export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/jvm/java-'$JAVA_JDK_VER'-openjdk-amd64/jre/lib/amd64/server"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

source $FILE
echo "Checking...JNI..."
ls $JAVA_HOME/include/jni.h

#update-java-alternatives -l
sudo update-alternatives --config java

#export TOMCAT_HOME=/usr/share/tomcat5
