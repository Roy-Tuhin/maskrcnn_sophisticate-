#!/bin/bash

##----------------------------------------------------------
### common configurations
##----------------------------------------------------------

MACHINE_ARCH=$(uname -m)

USER_ID=$(id -u)
GRP_ID=$(id -g)

USR=$(id -u -n)
GRP=$(id -g -n)

LOCAL_HOST=`hostname`

OSTYPE=$(uname -s) ## Linux, Darwin

### -------------------------------------------
## TOFO: make parameterized function to return specific color code

nocolor='\e[0m'    # text reset
biwhi='\e[1;97m';
bired='\e[1;91m';
biyel='\e[1;93m';
gre='\e[0;32m';
on_ired='\e[0;101m';
icya='\e[0;96m';

# # regular           bold                underline           high intensity      boldhigh intens     background          high intensity backgrounds
# bla='\e[0;30m';     bbla='\e[1;30m';    ubla='\e[4;30m';    ibla='\e[0;90m';    bibla='\e[1;90m';   on_bla='\e[40m';    on_ibla='\e[0;100m';
# red='\e[0;31m';     bred='\e[1;31m';    ured='\e[4;31m';    ired='\e[0;91m';    bired='\e[1;91m';   on_red='\e[41m';    on_ired='\e[0;101m';
# gre='\e[0;32m';     bgre='\e[1;32m';    ugre='\e[4;32m';    igre='\e[0;92m';    bigre='\e[1;92m';   on_gre='\e[42m';    on_igre='\e[0;102m';
# yel='\e[0;33m';     byel='\e[1;33m';    uyel='\e[4;33m';    iyel='\e[0;93m';    biyel='\e[1;93m';   on_yel='\e[43m';    on_iyel='\e[0;103m';
# blu='\e[0;34m';     bblu='\e[1;34m';    ublu='\e[4;34m';    iblu='\e[0;94m';    biblu='\e[1;94m';   on_blu='\e[44m';    on_iblu='\e[0;104m';
# pur='\e[0;35m';     bpur='\e[1;35m';    upur='\e[4;35m';    ipur='\e[0;95m';    bipur='\e[1;95m';   on_pur='\e[45m';    on_ipur='\e[0;105m';
# cya='\e[0;36m';     bcya='\e[1;36m';    ucya='\e[4;36m';    icya='\e[0;96m';    bicya='\e[1;96m';   on_cya='\e[46m';    on_icya='\e[0;106m';
# whi='\e[0;37m';     bwhi='\e[1;37m';    uwhi='\e[4;37m';    iwhi='\e[0;97m';    biwhi='\e[1;97m';   on_whi='\e[47m';    on_iwhi='\e[0;107m';

### -------------------------------------------

function info() {
  (>&2 echo -e "${biwhi}[INFO]: $*${nocolor}")
}

function error() {
  (>&2 echo -e "${bired}[ERROR]: $*${nocolor}")
}

function warning() {
  (>&2 echo -e "${biyel}[WARNING]: $*${nocolor}")
}

function ok() {
  (>&2 echo -e "${gre}[OK]: $*${nocolor}")
}

function debug() {
  (>&2 echo -e "${on_ired}[DEBUG]${nocolor}: ${icya}$*${nocolor}")
}

function print_delim() {
  echo '============================'
}

function get_now() {
  echo $(date +%s)
}

function print_time() {
  END_TIME=$(get_now)
  ELAPSED_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)
  MESSAGE="Took ${ELAPSED_TIME} seconds"
  info "${MESSAGE}"
}

function success() {
  print_delim
  ok "$1"
  print_time
  print_delim
}

function fail() {
  print_delim
  error "$1"
  print_time
  print_delim
  exit -1
}
