#!/bin/bash

##----------------------------------------------------------
### PHP
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## Change List
##----------------------------------------------------------
#
## 03-Aug-2018
## 1. Ubuntu 18.04 LTS installation added
#
## 05-Jul-2018
# 1. apt-get replaced with apt
# 2. PHP_VER variable introduced
# 3. local composer installation - commented by default
# 4. auto accept flag added
# 5. PHP_VER to be moved to central script: versions.sh
#
## TBD:
## 1. if repo is already added skip
## 2. if php is already install skip and show the version instead
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$PHP_VER" ]; then
  PHP_VER="7.2"
  echo "Unable to get PHP_VER version, falling back to default version#: $PHP_VER"
fi

##----------------------------------------------------------
## Ubuntu 16.04 LTS
##----------------------------------------------------------
#[php7 on Ubuntu 14.04](https://askubuntu.com/questions/873768/how-do-i-install-php7-on-ubuntu-14-04)
#[composer](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-14-04)

# Ubuntu 16.04 LTS
if [[ $LINUX_VERSION == "16.04" ]]; then
  echo $LINUX_VERSION
  ## Add ppa
  sudo -E add-apt-repository -y ppa:ondrej/php
  sudo -E apt update
  ##apt-cache search php7
  # 7.0, 7.1, 7.2 are available
fi

##----------------------------------------------------------
## Ubuntu 18.04 LTS
## https://ubuntuforums.org/showthread.php?t=2393823
##----------------------------------------------------------

# Ubuntu 18.04 LTS
if [[ $LINUX_VERSION == "18.04" ]]; then
  echo $LINUX_VERSION
  ## Uninstall ppa
  sudo -E apt-add-repository -y --remove ppa:ondrej/php
  sudo apt purge php$PHP_VER php$PHP_VER-common
fi

sudo -E apt -q -y install curl git
sudo apt install -y php$PHP_VER php$PHP_VER-cli

sudo -E apt -q -y install php-mysql

sudo -E apt -q install -y \
  php$PHP_VER-fpm \
  php$PHP_VER-gd \
  php$PHP_VER-json \
  php$PHP_VER-mysql \
  php$PHP_VER-readline \
  php$PHP_VER-xml \
  php$PHP_VER-mbstring \
  php$PHP_VER-curl \
  php$PHP_VER-zip

##----------------------------------------------------------
### Install PHP 7 Imagick Extension
## Tested on Ubuntu 16.04
##----------------------------------------------------------
## https://linoxide.com/ubuntu-how-to/install-php7-imagick-ubuntu-16/
##----------------------------------------------------------

# sudo apt install python-software-properties software-properties-common
sudo -E apt -q -y install php-imagick
echo ""
echo "PHP_VERify the installation: "
echo ""
php -m | grep imagick

##----------------------------------------------------------
### Install composer
##----------------------------------------------------------
source $LINUX_SCRIPT_HOME/php-composer.install.sh
