#~/bin/bash
user=`whoami`

bold=`tput bold`
bld=`tput smso`
nrml=`tput rmso`
reset=`tput reset`
red=$(tput setaf 1)
normal=$(tput sgr0)
rev=$(tput rev)
cyan_start="\033[36m"
cyan_stop="\033[0m"

arg1_stringToReplace=$1
arg2_fileNameInwhichToReplace=$2
arg3_replaceWith=$3

if [ -z $1 ]
then
	echo -e "${bold}${cyan_start}Enter the string that needs to be replaced $cyan_stop${normal}"
	read arg1_stringToReplace
	echo "You have entered: $arg1_stringToReplace"
fi

if [ -z $2 ]
then
	echo -e "${bold}${cyan_start}Enter the string tthe file Name in which to replace the string $cyan_stop${normal}"
	read arg2_fileNameInwhichToReplace
	echo "You have entered: $arg2_fileNameInwhichToReplace"
fi

if [ -z $3 ]
then
        echo -e "${bold}${cyan_start}Enter the string from which it needs to be replaced $cyan_stop${normal}"
        read arg3_replaceWith
        echo "You have entered: $arg3_replaceWith"
fi

if [ ! -z $arg1_stringToReplace -a $arg2_fileNameInwhichToReplace -a $arg3_replaceWith ]
then
	echo "arg1: $arg1_stringToReplace"
	echo "arg2: $arg2_fileNameInwhichToReplace"
	
	#fileNames=(`grep $arg1_stringToReplace $arg2_fileNameInwhichToReplace |cut -f1 -d':'`)
	fileName=$arg2_fileNameInwhichToReplace
	echo "File: $fileName"
        sed 's/$1/$3/g' $fileName

else
	exit -1
fi 

strReplace(){
	for i in fileNames
	do
		sed 's/$1/$3/g' $i
	done
}
