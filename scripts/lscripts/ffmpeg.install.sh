#!/bin/bash

##----------------------------------------------------------
## ffmpeg
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
# http://blog.aicry.com/ubuntu-14-04-install-opencv-with-cuda/
# https://ubuntuforums.org/showthread.php?t=2219550
# https://stackoverflow.com/questions/29125229/how-to-reinstall-ffmpeg-clean-on-ubuntu-14-04
# http://www.powercms.in/blog/how-install-ffmpeg-ubuntu-1404-1410-and-linux-mint

#sudo apt-get --purge ffmpeg
#sudo apt -y install ppa-purge

##Cannot add PPA: 'ppa:jon-severinsson/ffmpeg'.Please check that the PPA name or format is correct
#sudo ppa-purge ppa:jon-severinsson/ffmpeg
#sudo add-apt-repository -y ppa:jon-severinsson/ffmpeg

# sudo apt-add-repository -y --remove ppa:mc3man/trusty-media
# #sudo ppa-purge ppa:mc3man/trusty-media
# sudo add-apt-repository -y ppa:mc3man/trusty-media

sudo -E apt update
#sudo -E apt -q -y install ffmpeg frei0r-plugins
sudo -E apt -q -y install ffmpeg
