## utilities
openssh-client,openssh-server,dos2unix,tree,chromium-browser,unrar
vim,vim-gtk
sublime-text-installer

##
git,cvs,tkcvs

## exif tool
libimage-exiftool-perl

## Used in openCV
doxygen,doxygen-gui,graphviz

## Pre-requisite for CUDA, cuDNN, tensorflow etc.
python-numpy,python-dev,python-pip,python-wheel

## Misc
libexif-dev,ntp,libconfig++-dev,kino
wine (ppa:ubuntu-wine/ppa)

## vncserver
ubuntu-desktop,gnome-panel,gnome-settings-daemon,metacity,nautilus,gnome-terminal,vnc4server

## VLC
vlc,browser-plugin-vlc

## java
default-jre,default-jdk,openjfx,ant

## graphics

inkscape (ppa:inkscape.dev/stable), gimp (ppa:otto-kesselgulasch/gimp), meshlab (ppa:zarquon42/meshlab)
Blender

### visual effects (VFX) industry from the perspective of being either an artist, compositor, video editor, or systems engineer.
#### Natron
https://natron.fr/download/?os=Linux&d=https://downloads.natron.fr/Linux/releases/64bit/files/Natron-2.2.7-Linux-x86_64bit.tgz

### Terrain Generation
* picogen, povray, yafray, wings3D

## sound
audacity (ppa:ubuntuhandbook1/audacity)

## php 7.0 (ppa:ondrej/php)
php7.0,php7.0-cli,php7.0-fpm,php7.0-gd,php7.0-json,php7.0-mysql,php7.0-readline,php7.0-xml,php7.0-mbstring

## apache2
apache2,libapache2-mod-php,php-mcrypt,php-mysql,libapache2-mod-php7.0

## Database, Filesystem
### Postgres
python-pip,python-dev,libpq-dev,postgresql,postgresql-contrib,pgadmin3

### Elastic Search
elasticsearch

## look & feel
compizconfig-settings-manager, compiz-plugins

# computer vision, datasciene, photogrammetry etc.
octave, ros
nodejs

# Screen Recorders
* https://askubuntu.com/questions/4428/how-to-record-my-screen
* https://www.unixmen.com/vokoscreen-a-new-screencasting-tool-for-linux/
vokoscreen (ppa:vokoscreen-dev/vokoscreen)

# Screen-capture/Screen-shots
* http://tipsonubuntu.com/2015/04/13/install-the-latest-shutter-screenshot-tool-in-ubuntu/
shutter (ppa:shutter/ppa)

# Youtube downloader
* https://www.lifewire.com/download-youtube-videos-p2-2202105
youtube-dl ytd-gtk

# Markdown editors
* https://www.maketecheasier.com/markdown-editors-linux/
* https://www.maketecheasier.com/best-markdown-editor-for-windows/

## Remarkable
* http://remarkableapp.github.io
* http://remarkableapp.github.io/files/remarkable_1.87_all.deb
```bash
sudo apt -y install python3-bs4 wkhtmltopdf
sudo dpkg -i remarkable_1.87_all.deb
```

## Haroopad (my fav)
* http://pad.haroopress.com/user.html

## Teamviewer
* https://askubuntu.com/questions/453157/how-to-install-teamviewer-on-14-04
* https://community.teamviewer.com/t5/Knowledge-Base/Installation-of-TeamViewer-on-a-Ubuntu-system/ta-p/45
* https://www.teamviewer.com/en/download/linux/

```bash
game@game-pc:~/Downloads$ sudo apt install libjpeg62
Reading package lists... Done
Building dependency tree
Reading state information... Done
You might want to run 'apt-get -f install' to correct these:
The following packages have unmet dependencies:
 teamviewer:i386 : Depends: libjpeg62:i386 but it is not going to be installed
                   Depends: libxtst6:i386 but it is not going to be installed
E: Unmet dependencies. Try 'apt-get -f install' with no packages (or specify a solution).
```

```bash
teamviewer_12.0.76279_i386.deb
sudo dpkg --add-architecture i386;
sudo apt-get update; 
sudo dpkg -i teamviewer_12.0.76279_i386.deb
sudo apt-get -f install
```

## Google Earth
- https://itsfoss.com/install-google-earth-ubunu/

## References
### Comprehensive listing of Opensource softwares for all purposes:
* http://www.linuxrsp.ru/win-lin-soft/table-eng.html

### graphics
* https://en.wikipedia.org/wiki/Comparison_of_3D_computer_graphics_software
* https://en.wikibooks.org/wiki/Blender_3D:_Noob_to_Pro

### Terrain Generation
* https://en.wikibooks.org/wiki/Blender_3D:_Noob_to_Pro/Quickie_Texture
* https://en.wikipedia.org/wiki/Bump_mapping
* https://en.wikipedia.org/wiki/Heightmap
* https://en.wikipedia.org/wiki/Digital_elevation_model
* https://en.wikipedia.org/wiki/Terragen
* https://ubuntuforums.org/showthread.php?t=851846
* http://www.bottlenose.net/share/fracplanet/index.htm
* https://en.wikipedia.org/wiki/Picogen
* http://picogen.org/
* https://hubalternative.com/top-10-picogen-alternatives
* http://vterrain.org/Packages/Artificial/
#### povray
* http://www.povray.org/
* https://charmie11.wordpress.com/2016/01/29/pov-ray-3-7-installation-on-ubuntu-14-04/
#### wings3d
* http://www.wings3d.com/

### 2D-3D Floor Plans, Architecture
* https://en.wikipedia.org/wiki/Sweet_Home_3D
* https://sourceforge.net/projects/sweethome3d/files/SweetHome3D/stats/map


-------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
## How To's
Installation of software on Ubuntu
Additing ppa repositories
Automating configuration settings
-Adding unique line in ~/.bashrc file using script - helpful for 
Nvidia Graphics card driver installation on Ubuntu
CUDA Installation (CUDA toolkit)
cuDNN, tensorflow setup
Troubleshoot errors during installaions etc.
How do I add a PPA in a shell script without user input?
https://askubuntu.com/questions/304178/how-do-i-add-a-ppa-in-a-shell-script-without-user-input

* determine Ubuntu version number
```
cat /etc/issue.net

#
lsb_release -sr
14.04


lsb_release -si
Ubuntu

lsb_release -sc
trusty

lsb_release -ric
Distributor ID:	Ubuntu
Release:	14.04
Codename:	trusty

uname -m
x86_64

uname -smr # s->OS; m->ARCH; r->VER
Linux 4.4.0-75-generic x86_64

#to scriptize it
# https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
OS=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)
```
## apt
```
apt-cache search
apt-cache policy
sudo apt-get install
sudo apt-get -y install
```

