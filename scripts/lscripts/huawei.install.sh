#!/bin/bash

source ./color.sh

# Reference: https://stackoverflow.com/questions/192319/how-do-i-know-the-script-file-name-in-a-bash-script
me=`basename "$0"`
echo "executing... ${bred}$me${reset}"

source ./_huawei.get.sh

FILE=/lib/udev/rules.d/40-usb_modeswitch.rules
LINE="ATTR{idVendor}==\"$F1\", ATTR{idProduct}==\"$F2\", RUN+=\"usb_modeswitch '%b/%k'\""

echo ''
echo -e "Adding this line..."
echo -e "${bred}$LINE${reset}"
echo "to this file..."
echo -e "${bred} sudo vi $FILE${reset}"
echo "......."

grep -qF "$USBID" $FILE || sudo sh -c 'echo "$LINE" >> "$FILE"'

source ./_huawei.exe.sh
