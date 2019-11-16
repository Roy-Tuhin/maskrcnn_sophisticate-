#!/bin/bash

echo "Running following commands..."
echo -e ${bred}sudo touch /etc/usb_modeswitch.d/$USBID${reset}
echo -e ${bred}sudo usb_modeswitch -J -v 0x$F1 -p 0x$F2${reset}
#sudo usb_modeswitch -J -v 0x12d1 -p 0x1f01
echo "starting huawei data card..."
sudo touch /etc/usb_modeswitch.d/$USBID
sudo usb_modeswitch -J -v 0x$F1 -p 0x$F2