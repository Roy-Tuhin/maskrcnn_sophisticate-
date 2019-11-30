#!/bin/bash

ver=$1

if [ -z $ver ]; then
  ver=3
fi
pyenv="$(lsvirtualenv -b | grep ^py_$ver | tr '\n' ',' | cut -d',' -f1)"

echo $pyenv
