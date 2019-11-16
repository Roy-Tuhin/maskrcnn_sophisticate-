#!/bin/bash

prog=$1
ps aux | grep $prog | grep -v grep
echo ""
id=$(ps aux | grep $prog | grep -v grep | cut -d" " -f6 | tr '\n' ' ')
# sudo kill -9 $id
echo $id
