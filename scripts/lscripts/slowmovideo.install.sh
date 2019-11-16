#!/bin/bash

##----------------------------------------------------------
### slowmovideo
# http://slowmovideo.granjow.net/download.php
##----------------------------------------------------------

## slowmovideo
sudo -E add-apt-repository -y ppa:brousselle/slowmovideo
sudo -E apt-get update
sudo -E apt -q -y install slowmovideo
