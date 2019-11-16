#!/bin/bash

##----------------------------------------------------------
### Ruby
##----------------------------------------------------------
# sudo apt install ruby ruby-dev
sudo apt install -y ruby`ruby -e 'puts RUBY_VERSION[/\d+\.\d+/]'`-dev
ruby -v

##----------------------------------------------------------
### bundler, Jekyll
##----------------------------------------------------------
sudo gem update --system

# sudo gem install jekyll -v 2.4.0
sudo gem install bundler jekyll
gem -v