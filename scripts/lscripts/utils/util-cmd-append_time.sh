#!/bin/bash
 
##name=$1
name="test.txt"
 
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Current Time : $current_time"
 
new_name=$name.$current_time
echo "New FileName: " "$new_name"
 
cp $name $new_name
# mv $name $new_name
echo "You should see new file generated with timestamp on it.."
