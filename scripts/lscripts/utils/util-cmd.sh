#!/bin/bash


## Ref:
## https://stackoverflow.com/questions/14894605/shell-script-to-create-folder-daily-with-time-stamp-and-push-time-stamp-generate
## https://crunchify.com/shell-script-append-timestamp-to-file-name/


foldername=$(date +%Y%m%d)
echo $foldername
filename=$(date +%Y%m%d%H%M%S)
echo $filename

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Current Time : $current_time"

# /home/app/logs/$(date +%Y%m%d)/test$(date +%Y%m%d%H%M%S).log

current_path_without_full_path=${PWD##*/}
echo $current_path_without_full_path

CURRENT=`pwd`
BASENAME=`basename "$CURRENT"` ##basename external dependency
echo "$BASENAME"


## Ref:
## http://mywiki.wooledge.org/BashFAQ/028
## https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself

SCRIPT_PATH=$(dirname $(realpath -s $0)) ##realpath external dependency
echo $SCRIPT_PATH

SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
echo $SCRIPT_PATH

SCRIPT_PATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"  ##SCRIPT_PATH="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
echo $SCRIPT_PATH

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
echo $ABSOLUTE_PATH

## Ref:
## https://tecadmin.net/how-to-extract-filename-extension-in-shell-script/

# fullfilename=$1
fullfilename=$0
filename=$(basename "$fullfilename")
fname="${filename%.*}"
ext="${filename##*.}"

echo "Input File: $fullfilename"
echo "Filename without Path: $filename"
echo "Filename without Extension: $fname"
echo "File Extension without Name: $ext"

## Ref:
## https://stackoverflow.com/questions/2352380/how-to-get-extension-of-a-file-in-shell-script
file_ext=$(echo $filename |awk -F . '{if (NF>1) {print $NF}}')
echo $file_ext