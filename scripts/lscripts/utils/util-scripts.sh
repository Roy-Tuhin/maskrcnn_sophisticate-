#!/bin/bash

## scripts snipets

### Find something in all the files and print the line numbers and files and highlight the match

find . -iname '*' -type f -exec grep -inH --color='auto' 'userdir' {} \;
find . -type f -iname "*.*" -exec ls '{}' \; |less


find . -iname '*.make' -type f -exec sed -i 's/game1/bhaskar/g' {} \;
find . -iname '*.cmake' -type f -exec sed -i 's/game1/bhaskar/g' {} \;
find . -iname '*.json' -type f -exec sed -i 's/game1/bhaskar/g' {} \;
find . -iname '*.internal' -type f -exec sed -i 's/game1/bhaskar/g' {} \;
find . -iname '*.includecache' -type f -exec sed -i 's/game1/bhaskar/g' {} \;

sed -i 's/foo/bar/g' <fileName>

find . -type f -exec sed -i 's/foo/bar/g' {} +

# https://unix.stackexchange.com/questions/112023/how-can-i-replace-a-string-in-a-files

### [Generate SHA1 hash from a string](http://albertech.blogspot.in/2011/08/generate-sha1-hash-from-command-line-in.html)
echo -n password | sha1sum | awk '{print $1}'

### System Configurations
####**Verify You Have a Supported Version of Linux**
uname -m && cat /etc/*release
####**Verify the System has the Correct KernelHeaders and Development Packages Installed**
uname -r
sudo apt-get install linux-headers-$(uname -r)

### Developer toolchain versions
####**Verify the System Has gcc Installed**
gcc --version

* https://stackoverflow.com/questions/7222746/checksum-on-string
echo -n 'exampleString' | md5sum
echo -n "yourstring" |md5sum
echo -n "yourstring" |sha1sum
echo -n "yourstring" |sha256sum

### List All users

cut -d: -f1 /etc/passwd
##or
awk -F':' '{ print $1}' /etc/passwd

## [how-to-know-number-of-cores-of-a-system-in-linux](http://unix.stackexchange.com/questions/218074/how-to-know-number-of-cores-of-a-system-in-linux)
cat /proc/cpuinfo | grep "cpu cores"

## Check the service status on Ubuntu
sudo service --status-all

##https://unix.stackexchange.com/questions/144871/remove-all-nvidia-files
#It's not particularly useful here (where you can just fix your escaping as commented) but in the case where you want to search the whole dpkg -l line, you can run it through something like awk and then into apt-get purge with minimal conditioning:
sudo apt-get purge $(dpkg -l | awk '$2~/nvidia/ {print $2}')

#That should prompt you before it does anything but just in case, you could test it with:
apt-get -s purge $(dpkg -l | awk '$2~/nvidia/ {print $2}')

#To determine which distribution and release number you're running. The x86_64 line indicates you are running on a 64-bit system. The remainder gives information about your distribution.
uname -m && cat /etc/*release
##----------------------------------------------------------
## Nvidia graphics card deriver
##----------------------------------------------------------

## How do I find out the model of my graphics card?

##01:00.0 VGA compatible controller: NVIDIA Corporation GK208 [GeForce GT 730] (rev a1)
lspci  -v -s  $(lspci | grep VGA | cut -d" " -f 1)
lspci | grep VGA
sudo lswh -c video

# USB / Huawei Donggle
lsusb | grep -i Huawei |cut -d" " -f6

#https://www.maketecheasier.com/apt-vs-apt-get-ubuntu/



#
```
printenv
```

#
```
#!/usr/bin/env bash

cd $(dirname $0)
```
sudo apt install nfs-common 
sudo apt install smb4k 
sudo mount -t cifs //10.4.71.121/samba5 /mnt/samba121 -o username=bhaskar,workgroup=click2viewmap.com


# Image Magic
```bash
convert -resize 50% orig.png orig-1.jpg
```

# exiftool
```bash
# https://www.shellhacks.com/remove-exif-data-images-photos-linux/
# Install
sudo apt-get install libimage-exiftool-perl

# http://owl.phy.queensu.ca/~phil/exiftool/examples.html
# http://owl.phy.queensu.ca/~phil/exiftool/dummies.html
#
# Read Exif
exiftool a.jpg
# Remove EXIF Metadata from Image
exiftool -all= image.jpeg
# Remove EXIF Data from Multiply Files
exiftool -all= *
```

## One linears

**Get IP Address**
```bash
sudo apt install net-tools
ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
```

## Disk Space Monitoring
https://askubuntu.com/questions/413358/disk-is-full-but-cannot-find-big-files-or-folders
```
sudo du -sch /root/*
du -sch .[!.]* * |sort -h

#https://askubuntu.com/questions/36111/whats-a-command-line-way-to-find-large-files-directories-to-remove-and-free-up
find / -size +10M -size -12M -ls 
#
sudo du -sx /* 2>/dev/null | sort -n
#
sudo du -aBM 2>/dev/null | sort -nr | head -n 10
```

## System Setup
- separating data with softwares and sharing between dual/triple boot system

1. Dual boot Setup
SDD: 250 GB, 1 primary, 1 extended
- Ubuntu
- primary: ext4, ubuntu 16.04 installed
- extended: swap
HDD: 2 TB, 4 primary
- Windows 10
- 3 primary: 1,2 reserved by windows, 3rd window 10 installed [250GB0]
- 1 primary: 1.7 TB, ntfs

2. Move Data Folders in Ubuntu and Windows to a comman data partition
- https://www.pcworld.com/article/3025345/windows/move-your-windows-10-libraries-to-a-separate-drive-or-partition.html
- https://www.maketecheasier.com/move-home-folder-ubuntu/

Folder structure for comman storage on shared ntfs partition
- Documents
	- content

- Downloads
- Music
- Pictures
- Music
- Videos
- workspace
	- IDE related workspace area, OS specific
- softwares
	- installed from sources, downloaded executables
- Data
	- personal data and backup/archives of documents here
- K-bank
	- all knowledge bank
- public_html

mkdir -p Documents Downloads Pictures/icons Pictures/Memories-all Pictures/ArtGarphicsPhotography Pictures/Wallpapers Entertainment/Music Entertainment/Movies Entertainment/TVSeries Entertainment/Videos ISOImages workspace softwares Data K-bank public_html
mkdir -p Entertainment/Music Entertainment/Movies Entertainment/TVSeries Entertainment/Videos ISOImages workspace softwares Data K-bank public_html


game@game-pc:/media/game/Common$ sudo blkid
[sudo] password for game: 
/dev/nvme0n1: PTUUID="5a474f39" PTTYPE="dos"
/dev/nvme0n1p1: UUID="9fb4d18d-9510-438f-8a3e-3d767830af31" TYPE="ext4" PARTUUID="5a474f39-01"
/dev/nvme0n1p5: UUID="a72f5d05-f044-4e34-9b99-0fe844a8da48" TYPE="swap" PARTUUID="5a474f39-05"
/dev/sda1: LABEL="System Reserved" UUID="667A6C667A6C3549" TYPE="ntfs" PARTUUID="f29ce627-01"
/dev/sda2: UUID="7EB687D0B687877D" TYPE="ntfs" PARTUUID="f29ce627-02"
/dev/sda3: UUID="9CC866D0C866A7EA" TYPE="ntfs" PARTUUID="f29ce627-03"
/dev/sda5: LABEL="Common" UUID="EA6618266617F255" TYPE="ntfs" PARTUUID="f29ce627-05"
/dev/sr0: UUID="2017-07-19-13-22-19-00" LABEL="GV-N00031-1R" TYPE="iso9660"


UUID="EA6618266617F255" TYPE="ntfs" PARTUUID="f29ce627-05"
/dev/sda5 /media/game/Common fuseblk rw,nosuid,nodev,relatime,user_id=0,group_id=0,default_permissions,allow_other,blksize=4096 0 0
~                                                                                                                                               
## One Liners Hacks
# https://stackoverflow.com/questions/2764051/how-to-join-multiple-lines-of-file-names-into-one-with-custom-delimiter

# how-to-join-multiple-lines-of-file-names-into-one-with-custom-delimiter
ls -1 | paste -sd "," -
ls -m
ls -1 | tr '\n' ','
# replace last comma with new line
ls -1 | tr '\n' ',' | sed 's/,$/\n/'
ls -1 | awk 'ORS=","'
# Parsing ls in general is not advised, so alternative better way is to use find, for example:
# https://unix.stackexchange.com/q/128985/21471
find . -type f -print0 | tr '\0' ','
find . -type f | paste -d, -s

## Join command
# https://stackoverflow.com/q/8522851/55075
# https://stackoverflow.com/questions/8522851/concise-and-portable-join-on-the-unix-command-line

tr '\n' '|' <python.requirements.txt |sed 's/,$//g' | sed 's/|$//'

# Get Release Name
lsb_release -c
cat /etc/lsb-release
grep $(lsb_release -rs) /usr/share/python-apt/templates/Ubuntu.info | grep -m 1 "Description: Ubuntu " | cut -d "'" -f2
cat /etc/os-release
# NAME="Ubuntu"
# VERSION="18.04 LTS (Bionic Beaver)"
# ID=ubuntu
# ID_LIKE=debian
# PRETTY_NAME="Ubuntu 18.04 LTS"
# VERSION_ID="18.04"
# HOME_URL="https://www.ubuntu.com/"
# SUPPORT_URL="https://help.ubuntu.com/"
# BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
# PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
# VERSION_CODENAME=bionic
# UBUNTU_CODENAME=bionic


sudo sh -c 'echo "deb https://qgis.org/debian bionic main" > /etc/apt/sources.list.d/qgis3.list'

**Get PHP version**
php --version | cut -d'-' -f1 | grep -i php | cut -d' ' -f2

**remove packages**
# https://askubuntu.com/questions/22200/how-to-uninstall-a-deb-package

sudo apt-get remove packagename 
dpkg --remove packageName
sudo dpkg -r package_name

**Bash configuration**
export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$'

**Unzip/Unarchive**
unzip -q
tar xfz
tar xf

**Insert line at the top of the file**
- https://superuser.com/questions/246837/how-do-i-add-text-to-the-beginning-of-a-file-in-bash
- Pipe (|) the message (echo '...') to cat which uses - (standard input) as the first file and todo.txt as the second. cat conCATenates multiple files. Send the output (>) to a file named temp. If there are no errors (&&) from cat then rename (mv) the temp file back to the original file (todo.txt)
  * echo 'task goes here' | cat - todo.txt > temp && mv temp todo.txt
- https://unix.stackexchange.com/questions/99350/how-to-insert-text-before-the-first-line-of-a-file
  * sed  -i '1i text' filename
  * example:
    - sed -i '1i ---\n---' *.md

## System Admin
USER_ID=$(id -u)
GRP=$(id -g -n)
GRP_ID=$(id -g)
LOCAL_HOST=`hostname`

$USER