#!/bin/bash

i=1
b=0
p=0
while [ $i -le 100 ]                                                                                                         
do
   o=1
   while [ $b -ge 0 ]
   do
      echo "\b"
      (( b -= 1 ))
   done

   while [ $o -le $i ]
   do
	   #echo "="
	   (( o+=1 ))
   done

   b=$(( $o + 3 ))
   [ $p -eq 3 ] && p=0
   [ $p -eq 0 ] && CAR='|'
   [ $p -eq 1 ] && CAR='/'
   [ $p -eq 2 ] && CAR='\'
   (( p+=1 ))

   echo " ${CAR} $i%"
   sleep 1
   (( i += 1 ))
done
