#!/bin/bash

##----------------------------------------------------------
### Install composer
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

# if [ -z $LSCRIPTS ];then
#   LSCRIPTS="."
# fi

# source $LSCRIPTS/linuxscripts.config.sh

# if [ -z "$PHP_VER" ]; then
#   PHP_VER="7.2"
#   echo "Unable to get PHP_VER version, falling back to default version#: $PHP_VER"
# fi

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

## local (without sudo)
#
# mkdir $HOME/bin
# curl -sS https://getcomposer.org/installer | php -- --install-dir=$HOME/bin --filename=composer
# FILE=$HOME/.bashrc
# LINE='export PATH="$PATH:$HOME/bin"'
# grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
# source $FILE

#sudo mv composer.phar /usr/local/bin/composer
composer -h
