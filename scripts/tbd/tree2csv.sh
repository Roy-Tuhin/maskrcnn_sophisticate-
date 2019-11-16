#!/bin/bash
curdir=`pwd`
bold=`tput bold`
bld=`tput smso`
nrml=`tput rmso`
reset=`tput reset`
red=$(tput setaf 1)
normal=$(tput sgr0)
rev=$(tput rev)
cyan_start="\033[36m"
cyan_stop="\033[0m"
echo "Total number of param: $#"
echo "Param values: $@"
numOfParam=$#
arg1=""
arg2=""
arg3=""
arg4=""
arg5=""
arg1=$1
arg2=$2
arg3=$3
arg4=$4
arg5=$5

banner() {
        echo -e "${bold}${cyan_start} Usage: ${cyan_stop}${normal}"
	echo -e "${bold}${red} LINUX> tree2csv.sh <dirPath> [-f] [-t <fileExtension>] [<csvFileName>]${normal}"
        echo -e "\033[5m Default md5sum is calculated for all types of file... \033[0m "
	echo -e "\033[5m  -f will print full path name with each component \033[0m "
        echo -e "${bold}$cyan_start Example: $cyan_stop${normal}"
        echo -e "${bold}${red}          LINUX> tree2csv.sh . -t class${normal}"
}

genfilebanner(){
  echo -n "                                             "
  echo -e '\E[37;44m'"\033[1m\033[4mGENERATED FILES\033[0m\033[0m"
  echo "------------------------------------------------------------------------------------------------------------"
  echo
  echo -e  '\E[33;44m'"1. $csvFileName                  : CSV File without md5sum"
  echo -e  '\E[33;44m'"2. md5sum$csvFileName            : CSV File with md5sum"
  echo -e  '\E[33;44m'"3. DirOnly$csvFileName           : CSV File for Directories alone."
  echo -e  '\E[33;44m'"4. Tree`echo $csvFileName|cut -f1 -d'.'`.txt             : Tree structure for all files"
  echo -e  '\E[33;44m'"5. DirOnlyTree`echo $csvFileName|cut -f1 -d'.'`.txt      : Tree structure for Directories alone.";tput sgr0
}

numbOfInput(){
	echo "arg1: $arg1"
	echo "arg2: $arg2"
	echo "arg3: $arg3"
	echo "arg4: $arg4"
	echo "arg5: $arg5"
	case $numOfParam in
		[1-5])
			paramchk	
			;;
		*)
			echo "Invalid number of arguments!!"
			banner
			exit -1
			;;
	esac
}

paramchk(){
	if [ ! -z $arg1 ]
	then
		if [ $arg1 = "-t" -o $arg1 = "-f" ]
		then
			echo "Invalid arg1: $arg1"
			exit -1
		fi
	        treegen=$arg1
	fi

	if [ ! -z $arg2 ]
	then
		case $arg2 in
		        -f)
        		        arg2="-f"
				tpram=$arg2
                		;;
		        -t)
				if [ -z $arg3 ]
				then
					echo "Invaild file Type..."
					exit -1
				elif [ $arg3 = "-f" ]
				then
					echo "Invaild file Type..."
					exit -1
				else
					filetypearg=$arg3
				fi
        		        arg2="-t"
				;;
	        	*)
                		csvFileName=$arg2
		                ;;
		esac
	fi
	
	if [ ! -z $arg3 ]
	then
		case $arg3 in
        	        -f)
				echo "Invaild arg2: $arg2..."
				echo "arg3: $arg3..."
				exit -1
                        	;;
	                -t)
				if [ -z $arg4 ]
				then
					echo "Invaild file Type..."
					exit -1
				else
					filetypearg=$arg4
				fi
        	                arg3="-t"
	                        ;;
        	        *)
				if [ $arg2 = "-t" ]
				then
					filetypearg=$arg3
				else
	                	        csvFileName=$arg3
				fi
				echo hi
                        	;;
	        esac
	
		if [ $arg2 = $arg3 ]
		then
			echo "arg2=$arg2 and arg3=$arg3 CANNOT be same!" 
			exit -1
		fi
	fi
	
	if [ ! -z $arg4 ]
	then
		case $arg4 in
			-f)
                                echo "Invaild arg4: $arg4..."
                                exit -1
                                ;;
                        -t)
                                echo "Invaild arg4: $arg4..."
                                exit -1
                                ;;
        	        *)
                                if [ $arg3 = "-t" ]
                                then
                                        filetypearg=$arg4
                                fi
				if [ ! -z $arg5 ]
				then
					if [ $arg5 = "-t" -o $arg5 = "-f" ]
					then
                                		echo "Invaild arg5: $arg5..."
		                                exit -1
					else
	                                        csvFileName=$arg5
					fi
				fi
	                        ;;
        	esac
	fi

echo "csvFileName: $csvFileName"
echo "filetypearg: $filetypearg"
}

treeparam(){
	echo $tpram
	if [ ! -z "$tpram" ]
	then
		case $tpram in
			-f)	echo "Generating tree with full path..."
				fgentree
				;;
			*)	echo "Invalid Option..."
				exit -1
				;;
		esac
	else
		echo "Generating tree WITOUT full path..."
		gentree
	fi
#	echo $treegen
}

fileTypChk(){
	#echo "Creating file type array"
	i=`echo $filetypearg |awk '{split($0,array,",")} END{print length(array)}'`
        #echo $i
        for (( j=1; j <= $i; j++ ))
        do
        	filetype[`expr $j - 1`]=`echo $filetypearg |awk '{split($0,array,",")} END{print array['"$j"']}'`
                if [ $j -eq 1 ]
                then
                	filecond="'${filetype[`expr $j - 1`]}'"
                else
                        filecond="$filecond -o \$filetypearg = '${filetype[`expr $j - 1`]}'"
                fi
        done
}

userinput(){
	if [ -z "$treegen" ]
	then
	        banner
	        exit -1
	fi
	
	if [ -z $csvFileName ]
	then
	        csvFileName=tempTree.csv
	       # echo "Default csvFileName: $csvFileName"
	fi

	if [ -f md5sum$csvFileName ]
	then
	        >|md5sum$csvFileName
	fi

	echo "$arg1,$arg2,$arg3,$arg4,$arg5"
	if [ -z $arg2 -o -z $arg3 ]
	then
		#tpram="-f"
		filetype[0]="all" 
	elif [ ! -z $arg2 -o ! -z $arg3 ]
	then
		if [ $arg2 = "-t" -o $arg3 = "-t" ]
		then
	        case $arg2 in
        	        -t)
	                        if [ -z $arg3 ]
        	                then
					banner
                        	        exit -1
				fi
				fileTypChk
				;;
		esac
		case $arg3 in
			-t)
                                if [ -z $arg4 ]
                                then
                                        banner
                                        exit -1
                                fi
				fileTypChk
        	                ;;
        	 esac
		fi
	fi

	for (( v=0; v < ${#filetype[*]}; v++ ))
	do
		case ${filetype[v]} in
	        	class)
	                	classflag="true"
	                        ;;
	                java)
	                	javaflag="true"
	                        ;;
	                properties)
				propertiesflag="true"
	                        ;;
	               *)
	                        ;;
        	esac
	done

	#echo ${#filetype[@]}
	#echo ${filetype[@]}
}

fgentree(){
	tree -f --noreport --dirsfirst $treegen > $csvFileName
	tree -f --noreport --dirsfirst $treegen > Tree`echo $csvFileName|cut -f1 -d'.'`.txt
	tree -f --noreport -d $treegen > DirOnly$csvFileName
	tree -f --noreport -d $treegen > DirOnlyTree`echo $csvFileName|cut -f1 -d'.'`.txt
}
gentree(){
	# Without -f option: will not display complete path name in the tree structure
	tree --noreport --dirsfirst $treegen > $csvFileName
	tree --noreport --dirsfirst $treegen > Tree`echo $csvFileName|cut -f1 -d'.'`.txt
	tree --noreport -d $treegen > DirOnly$csvFileName
	tree --noreport -d $treegen > DirOnlyTree`echo $csvFileName|cut -f1 -d'.'`.txt
}

gencsv(){
	#for $csvFileName	
	sed -i 's/ //g' $csvFileName
	sed -i 's/[\|,`]--/,/g' $csvFileName
	sed -i 's/|/,/g' $csvFileName
	sed -i 's/$/,/g' $csvFileName
	#for DirOnly$csvFileName
	sed -i 's/ //g' DirOnly$csvFileName
	sed -i 's/[\|,`]--/,/g' DirOnly$csvFileName
	sed -i 's/|/,/g' DirOnly$csvFileName
	sed -i 's/$/,/g' DirOnly$csvFileName

#genlevelFileName=
}

genLevel(){
	if [ -f aryLen.tmp ]
	then
	        rm aryLen.tmp
	fi
	#echo "Number of Lines in CSV File: ${#count[*]}"
	word=(`cat md5sum$csvFileName| awk '{gsub(",","^");print}'`)
	#echo "# of lines ${#word[*]}"

	for (( j=0; j < ${#word[*]}; j++ ))
	do
		echo ${word[j]} | awk '{split($0,array,"^")} END{print length(array)}' >> aryLen.tmp
	done
	#echo "done"

	#echo `sort -u -n -r aryLen.tmp`
	level=(`sort -u -n -r aryLen.tmp`)
	#echo ${#level[*]}

	for (( k=0; k < ${level[0]}; k++ ))
	do
	        newline=$newline"Level_$k,"
	done
	echo $newline
	
	sed -i '$d' md5sum$csvFileName
	sed -i '1d' md5sum$csvFileName
	sed -i '1i\'$newline'' md5sum$csvFileName
	sed -i '$d' $csvFileName
	sed -i '1d' $csvFileName
	sed -i '1i\'$newline'' $csvFileName

}

genmd5() {
                if [ ${fileext[i]} = ${filetype[0]} ]
                then
                        echo "${line[i]}`md5sum ${mdfile[i]}|cut -f1 -d' '`," >> md5sum$csvFileName
                else
                        echo "${line[i]}" >> md5sum$csvFileName
                fi
}

genmd5All(){
	echo "Tpram: $tpram"
	if [ -z $tpram ]
	then
		if [ $tpram = "-f" ]
		then
			echo "${line[i]}`md5sum $treegen/${mdfile[i]}|cut -f1 -d' '`," >> md5sum$csvFileName
		else
			if [ $treegen = "." ]
			then
				echo "${line[i]}`md5sum $curdir/${mdfile[i]}|cut -f1 -d' '`," >> md5sum$csvFileName
				#echo "${line[i]}md5sum `echo $curdir/${mdfile[i]}|cut -f1 -d' '`," 
			else
				echo "${line[i]}`md5sum $treegen/${mdfile[i]}|cut -f1 -d' '`," >> md5sum$csvFileName
				#echo "${line[i]}md5sum `echo $treegen/${mdfile[i]}|cut -f1 -d' '`," 
			fi
		fi
	fi
	
}

genmd5Main(){
	line=(`cat $csvFileName`)
	for (( i=0; i < ${#line[*]}; i++ ))
	do
	        count[i]=${line[i]}
		mdfile[i]=`echo ${line[i]}|rev|cut -f2 -d','|rev`
		if [ -f ${mdfile[i]} ]
		then
			#echo  ${mdfile[i]}
			fileext[i]=`echo ${mdfile[i]}|rev|cut -f1 -d'.'|rev`
			if [ ${filetype[0]} = "all" ]
			then
				genmd5All
			else
				genmd5
			fi
		else
			echo "${line[i]}" >> md5sum$csvFileName
		fi
	done
}
numbOfInput
userinput
treeparam
gencsv
genmd5Main
genLevel
genfilebanner
