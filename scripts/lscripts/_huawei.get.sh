#!/bin/bash

USBID=$(lsusb | grep -i Huawei | cut -d' ' -f6)
echo -e USB ID is...${bred}$USBID${reset}
F1=$(echo $USBID | cut -d':' -f1)
F2=$(echo $USBID | cut -d':' -f2)