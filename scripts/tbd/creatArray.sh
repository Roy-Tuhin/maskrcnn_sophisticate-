#!/bin/bash

#array=(red green blue yellow magenta)
array=(`ls`)
len=${#array[*]}
echo "The array has $len members. They are:"
i=0
while [ $i -lt $len ]; do
	echo "$i: ${array[$i]}"
	let i++
done
