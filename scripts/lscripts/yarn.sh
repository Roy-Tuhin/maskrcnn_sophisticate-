#!/bin/bash

# Reference:
# https://yarnpkg.com/lang/en/docs/install/#debian-stable
# about: https://code.facebook.com/posts/1840075619545360
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
