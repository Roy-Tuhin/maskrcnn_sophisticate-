#!/bin/bash

## https://vulkan.lunarg.com/sdk/home

wget -qO - http://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo apt-key add -
sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.1.130-bionic.list http://packages.lunarg.com/vulkan/1.1.130/lunarg-vulkan-1.1.130-bionic.list
sudo apt -y update
sudo apt -y install vulkan-sdk
