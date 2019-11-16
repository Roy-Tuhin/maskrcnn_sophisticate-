#!/bin/bash

##----------------------------------------------------------
### R
##----------------------------------------------------------
# https://www.digitalocean.com/community/tutorials/how-to-set-up-r-on-ubuntu-14-04
# https://cran.r-project.org
# https://cran.r-project.org/bin/linux/ubuntu/README

sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install r-base

# Install R-packages
## many R packages are hosted on CRAN and can be installed using the built-in install.packages() function
## Available for all users


# shiny - This package, which is a very popular package used to create web applications from R code.
## http://shiny.rstudio.com/

sudo su - -c "R -e \"install.packages('shiny', repos = 'http://cran.rstudio.com/')\""

# there are many more packages that are hosted on GitHub but are not on CRAN.
#To install R packages from GitHub, we need to use the devtools R package, so let's install it. Install dependencies for devtools R package
#sudo apt-get -y install libcurl4-gnutls-dev libxml2-dev libssl-dev
#sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""

#we have devtools installed, we can install any R package that is on GitHub using the install_github() function
