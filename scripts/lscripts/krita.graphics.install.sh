#!/bin/bash

##----------------------------------------------------------
### krita
# https://krita.org/en/download/krita-desktop/
##----------------------------------------------------------

## krita
sudo -E add-apt-repository -y ppa:kritalime/ppa
sudo -E apt-get update
sudo -E apt-get install -y krita

# If you also want to install translations:
# sudo apt-get install krita-l10n
