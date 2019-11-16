#!/bin/bash
# search and install package(s)

output=$(apt-search $1 |grep $1|tr ':\n' ' ');
# Install blidfold is risky, show the user the command to be executed
echo "sudo apt install $output"

# TBD: ask user for continue with the above install command execution or terminate

