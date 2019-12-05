#!/bin/bash

# Install PHP before installing apache2
# source ./php.install.sh

##----------------------------------------------------------
### Apache
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## Change List
##----------------------------------------------------------
## 05-Jul-2018
# 1. apt replaced with apt
# 2. PHP_VER variable introduced
# 3. versions.sh central script for version control of softwares
##----------------------------------------------------------
## Issues:
##----------------------------------------------------------
## 1. If using PHP version 7.2 php-crypt not yet available
## Package php-mcrypt is a virtual package provided by:
##   php7.1-mcrypt 7.1.18-1+ubuntu18.04.1+deb.sury.org+1
##   php5.6-mcrypt 5.6.36-1+ubuntu18.04.1+deb.sury.org+1
##   php7.0-mcrypt 7.0.30-1+ubuntu18.04.1+deb.sury.org+1
#
## # E: Package 'php-mcrypt' has no installation candidate
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

# Recommended: Install PHP before installing Apache2
#source $LSCRIPTS/php.install.sh

if [ -z "$PHP_VER" ]; then
  PHP_VER="7.2"
  echo "Unable to get PHP version, falling back to default version#: $PHP_VER"
fi

# ## Uninstall Apache2 before installing
# sudo apt purge apache2 apache2-data apache2-utils apache2.2-bin apache2-common
# sudo apt autoremove

sudo -E apt -q -y install apache2

#### Install PHP and MySQL modules for Apache2
# sudo -E apt -q -y install php libapache2-mod-php php-mcrypt php-mysql libapache2-mod-php$PHP_VER
sudo -E apt -q -y install libapache2-mod-php$PHP_VER
sudo -E apt -q -y install libapache2-mod-wsgi
sudo -E apt -q -y install libapache2-mod-wsgi-py3

source $LINUX_SCRIPT_HOME/apache2.config.sh

# For automation Apache test should be commented out
#### Apache test
# sudo apache2ctl configtest
# sudo systemctl status apache2

## sudo service --status-all
## sudo vi /etc/apache2/apache2.conf
## gvim /etc/apache2/sites-available/000-default.conf
## ls /var/log/apache2/
## tail -f /var/log/apache2/error.log

##* How to see the available options for PHP modules and libraries?
## apt-cache search php- | less

## * To get more information about what each module does:-
## apt-cache show package_name


# sudo vi /etc/apache2/mods-available/php$PHP_VER.conf
# # Running PHP scripts in user directories is disabled by default
# # 
# # To re-enable PHP in user directories comment the following lines
# # (from <IfModule ...> to </IfModule>.) Do NOT set it to On as it
# # prevents .htaccess files from disabling it.
# <IfModule mod_userdir.c>
#     <Directory /home/*/public_html>
#         #php_admin_flag engine Off
#         AllowOverride All
#     </Directory>
#     <Directory /home/*/public_html/*/cgi-bin>
#         DirectoryIndex index.py
#         Options +ExecCGI
#         # comment SetHandler if both py and wsgi to be enabled
#         SetHandler cgi-script
#         AddHandler cgi-script .py
#         #AddHandler wsgi-script .wsgi
#         #SetHandler wsgi-script
#     </Directory>
#     <Directory /home/*/public_html/*/wsgi-bin>
#         Options +ExecCGI
#         DirectoryIndex index.wsgi
#         SetHandler wsgi-script
#         AddHandler wsgi-script .wsgi
#     </Directory>
# </IfModule>

# # sudo vi /etc/apache2/mods-available/userdir.conf
# # ```bash
# # <IfModule mod_userdir.c>
# #         UserDir public_html
# #         UserDir disabled root

# #         <Directory /home/*/public_html>
# #                 #AllowOverride FileInfo AuthConfig Limit Indexes
# #                 AllowOverride All
# #                 Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
# #                 <Limit GET POST OPTIONS>
# #                         Require all granted
# #                 </Limit>
# #                 <LimitExcept GET POST OPTIONS>
# #                         Require all denied
# #                 </LimitExcept>
# #         </Directory>
# #         <Directory /home/*/public_html/*/cgi-bin>
# #                 Options +ExecCGI
# #                 SetHandler cgi-script
# #                 AddHandler cgi-script .py
# #         </Directory>
# #         <Directory /home/*/public_html/*/wsgi-bin>
# #                 #Order allow,deny
# #                 #Allow from all
# #                 Options +ExecCGI
# #                 DirectoryIndex index.wsgi
# #                 SetHandler wsgi-script
# #                 AddHandler wsgi-script .wsgi
# #                 WSGIScriptReloading On
# #         </Directory>
# # </IfModule>

# # ```
