#!/bin/bash
csvFileName=$1
if [ -z $csvFileName ]
then
	echo "usage: md5chk.sh <csvFileName>"
fi
#md5sumary=(`grep ".class," $csvFileName |rev|cut -f2 -d','|rev`)
md5sumary=(`grep "./" $csvFileName |rev|cut -f2 -d','|rev`)
for (( i=0; i < ${#md5sumary[*]}; i++ ))
do
         echo "${md5sumary[i]},`md5sum ${md5sumary[i]}|cut -f1 -d' '`"
done

