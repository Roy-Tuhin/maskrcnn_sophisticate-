#!/bin/bash

##----------------------------------------------------------
### R-studio Server
##----------------------------------------------------------
# https://www.rstudio.com/products/rstudio/download-server/
sudo apt-get -y install gdebi-core
wget -c https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
sudo gdebi rstudio-server-1.0.143-amd64.deb
#RStudio can be access through port 8787. Any user account with a password can be used in RStudio.
#sudo rstudio-server restart
#sudo rstudio-server stop
#sudo rstudio-server start
