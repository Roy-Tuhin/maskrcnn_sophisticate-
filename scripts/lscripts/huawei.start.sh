#!/bin/bash

source ./color.sh

me=`basename "$0"`
echo "executing... ${bred}$me${reset}"

source ./_huawei.get.sh
source ./_huawei.exe.sh
