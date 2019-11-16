#!/bin/bash
# search and check if package is installed
output=$(apt-cache search $1 | cut -d' ' -f1 |tr '\n' ' ');apt-cache policy $output
