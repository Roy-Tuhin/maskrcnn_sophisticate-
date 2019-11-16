#!/bin/bash

TRAIL=$(echo $PATH | sed -e 's/:/ /g')
for STEP in $TRAIL
do
  find $STEP -maxdepth 1 | xargs file | grep executable | sed -e 's/:.*$//'
done
