#!/bin/bash

##----------------------------------------------------------
### Java
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## Change List
##----------------------------------------------------------
## 06-Jul-2018
# 1. JAVA_JDK_VER variable introduced
# 2. JAVA_JDK_VER to be moved to central script: versions.sh
#
## TBD:
# 2. if already install skip and show the version instead
##----------------------------------------------------------
## References
##----------------------------------------------------------
# https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt
#
# Intall OpenJDK-8 on ubuntu 14.04
# https://askubuntu.com/questions/464755/how-to-install-openjdk-8-on-14-04-lts
# https://unix.stackexchange.com/questions/289166/is-the-openjdk-r-ppa-trustworthy-enough-to-install-on-serJAVA_JDK_VER
# http://column80.com/api.v2.php?a=askubuntu&q=464755
# https://launchpad.net/~openjdk-r/+archive/ubuntu/ppa
# http://openjdk.java.net/projects/jdk8/
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$JAVA_JDK_VER" ]; then
  JAVA_JDK_VER="8"
  echo "Unable to get JAVA_JDK_VER version, falling back to default version#: $JAVA_JDK_VER"
fi

##JAVA_JDK_VER="1.8.0"
#JAVA_JDK_VER="8"
#JAVA_JDK_VER="9"

# Error while installing JDK 9
# The following packages have unmet dependencies:
#  openjdk-9-jdk : Depends: openjdk-9-jre (= 9~b114-0ubuntu1) but it is not going to be installed
#                  Depends: openjdk-9-jdk-headless (= 9~b114-0ubuntu1) but it is not going to be installed
# E: Unable to correct problems, you have held broken packages.

# sudo add-apt-repository -y ppa:openjdk-r/ppa

sudo -E apt update
# Example: openjdk-$JAVA_JDK_VER-jdk, openjdk-$JAVA_JDK_VER-jdk
sudo -E apt -q -y install openjdk-$JAVA_JDK_VER-jdk

# sudo -E apt -q -y install default-jre
# sudo -E apt -q -y install default-jdk

sudo -E apt -q -y install openjfx ## JavaFX
sudo -E apt -q -y install ant

##----------------------------------------------------------
### Java Config
##----------------------------------------------------------
source $LINUX_SCRIPT_HOME/java.config.sh

# sudo update-alternatives --config java
# sudo update-alternatives --config javac
