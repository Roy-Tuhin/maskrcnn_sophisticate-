#!/bin/bash

echo "Ex: dynamicAry.sh -t class,sh,txt ."
echo "Default md5sum is calculated for all types of file..."

arg1=$1
arg2=$2

declare -a filetype

echo "$arg1,$arg2"

if [ ! -z $arg1 ]
then
	case $arg1 in
		-t) 
			if [ -z $arg2 ]
			then
				echo " Usage: dynamicAry.sh -type class,sh,txt ."
				exit -1
			else
				echo "Creating file type array"

				i=`echo $arg2 |awk '{split($0,array,",")} END{print length(array)}'`
				echo $i
				for (( j=1; j <= $i; j++ ))
				do
				    filetype[`expr $j - 1`]=`echo $arg2 |awk '{split($0,array,",")} END{print array['"$j"']}'`
				    if [ $j -eq 1 ]
				    then
				    	filecond="'${filetype[`expr $j - 1`]}'"
				    else	
					filecond="$filecond -o \$arg2 = '${filetype[`expr $j - 1`]}'"
				    fi
				   	
				done
				#echo ${filetype[@]}
				#echo ${#filetype[@]}
				var1="a -o $arg2 = b"
				echo $var1
				var2="c"
				#echo $filecond
				if [ "$arg2" = "$var1" ]
				#if [ $var1 = "a" -o $var2 = "b" ]
				then
					echo hi
				fi
			fi
                        ;;
                *)      echo "Default md5sum is calculated for all types of file..."
                        ;;
         esac
fi
