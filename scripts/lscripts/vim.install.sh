#!/bin/bash

##----------------------------------------------------------
### vim
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------

#sudo -E apt update
#sudo -E apt -q -y remove vim vim-gtk && sudo apt-get -y autoremove
sudo -E apt -q -y install vim vim-gtk
#TBD: this may receates the file, hence risks loosing existing configurations
sudo sh -c 'echo "set expandtab\nset tabstop=2\nset nu\n" > /etc/vim/vimrc.local'

# :set tabstop=4
# :set shiftwidth=4
# :set expandtab
