#!/bin/bash
# Description: Linux System Information Report in HTML format # Version 2.0 # Useage: sysreport > /var/www/html/report.html # License: BSD # Author: Greg Ippolito 


cat << HEAD
--------------------------------------------------------------------------------


System Report for " HEAD echo `hostname` cat << BODY1 "


--------------------------------------------------------------------------------

BODY1 cat << HOSTNAME 

OS System Configuration:
hostname: HOSTNAME /bin/hostname cat << RELEASE 
OS Release: RELEASE /bin/cat /etc/*-release cat << HOSTID 
$HOSTID
hostid: HOSTID /usr/bin/hostid cat << UNAMEO 

Kernel OS: UNAMEO uname --operating-system cat << UNAMER 

Kernel release: UNAMER uname --kernel-release cat << UNAMEV 

Kernel version: UNAMEV uname --kernel-version cat << UNAMEK 

Harware Platform: UNAMEK uname --hardware-platform cat << UNAMEPM 

Processor Architecture: UNAMEPM uname --processor cat << CHKCONFIG 

System services: (chkconfig) 

CHKCONFIG
/sbin/chkconfig --list|grep on
cat << CHKCONFIGEND

CHKCONFIGEND cat << CRONTAB 

File: /etc/crontab 

CRONTAB
cat /etc/crontab
cat << CRONTABEND

CRONTABEND echo "



--------------------------------------------------------------------------------

" echo "

Network Configuration:
" cat << HOSTS 
File: /etc/hosts: 

HOSTS
cat /etc/hosts
cat << HOSTSEND

HOSTSEND cat << SWITCH File: /etc/nsswitch.conf: 

SWITCH
cat /etc/nsswitch.conf
cat << SWITCHEND

SWITCHEND cat << RESOLV File: /etc/resolv.conf: 

RESOLV
cat /etc/resolv.conf

cat << RESOLVEND

RESOLVEND cat << IFCONFIG ifconfig: 

IFCONFIG
/sbin/ifconfig
cat << IFCONFIGEND

IFCONFIGEND cat << ROUTE /sbin/route: 

ROUTE
/sbin/route
cat << ROUTEEND

ROUTEEND if [[ -r /etc/sysconfig/network ]]; then cat << IFCFGN Network Configuration File: /etc/sysconfig/network: 

IFCFGN
cat /etc/sysconfig/network
cat << IFCFGENDN

IFCFGENDN fi cat << IFCFG Files /etc/sysconfig/network-scripts/ifcfg-eth*: 

IFCFG
cat /etc/sysconfig/network-scripts/ifcfg-eth*
cat << IFCFGEND

IFCFGEND echo "



--------------------------------------------------------------------------------

" if [[ -r /etc/mail/local-host-names || -r /etc/sendmail.cw || -r /etc/aliases || -r /etc/mail/virtusertable ]]; then echo "

Mail Server Configuration:
" if [[ -r /etc/mail/local-host-names ]]; then # Redhat 7.1 - Fedora Core X cat << SENMAILCFGN2 Mail Hosts File: /etc/mail/local-host-names: 
SENMAILCFGN2
cat /etc/mail/local-host-names
cat << SENMAILCFGN2

SENMAILCFGN2 elif [[ -r /etc/sendmail.cw ]]; then # Redhat 6.x cat << SENMAILCFGN Mail Hosts File: /etc/sendmail.cw: 

SENMAILCFGN
cat /etc/sendmail.cw
cat << SENMAILCFGN

SENMAILCFGN fi if [[ -r /etc/mail/virtusertable ]]; then cat << SENMAILCFGV Sendmail Virtual Table File: /etc/mail/virtusertable: 

SENMAILCFGV
cat /etc/mail/virtusertable
cat << SENMAILCFGV

SENMAILCFGV fi if [[ -r /etc/aliases ]]; then cat << SENMAILCFGN eMail Aliases File: /etc/aliases: 

SENMAILCFGN
cat /etc/aliases
cat << SENMAILCFGN

SENMAILCFGN fi fi echo "



--------------------------------------------------------------------------------

" cat << DF 

Storage:
df -k: 
DF
df -k
cat << DFEND

DFEND cat << FDISK Disk Partitions: /sbin/fdisk -l: 

FDISK
/sbin/fdisk -l
cat << FDISKEND

FDISKEND cat << FSTAB File: /etc/fstab: 

FSTAB
cat /etc/fstab
cat << FSTABEND

FSTABEND echo "


--------------------------------------------------------------------------------

" cat << HARDWARE 

Hardware Configuration:
CPU info: 
HARDWARE
cat /proc/cpuinfo

cat << SWAP

Total Swap Memory: 

SWAP grep SwapTotal: /proc/meminfo cat << MEM 
System Memory: 

MEM grep MemTotal /proc/meminfo cat << MEMEND 
MEMEND cat << PCI /sbin/lspci: 

PCI
/sbin/lspci
cat << PCIEND

PCIEND cat << HWCONF Devices: 

File: /etc/sysconfig/hwconf 
HWCONF
cat /etc/sysconfig/hwconf
cat << HWCONFEND

HWCONFEND cat << BODYEND 



--------------------------------------------------------------------------------

BODYEND 

HEAD
