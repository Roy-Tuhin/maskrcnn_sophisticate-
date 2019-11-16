#~/bin/bash
user=`whoami`
wasroot="/home/was6/IBM/WebSphere/AppServer"
profilePath=""
profileName=""
ans=""
cont=""
option=""
scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
serverlog=""
ffdclog=""
cmdArgNo=""
arg0=$0
arg1=$1
arg2=$2
currentPath=`pwd`
profileuserList=(`grep path $wasroot/properties/profileRegistry.xml|grep $user | awk {'print $5'}| grep $user |cut -sd'"' -f2|cut -f3 -d'/'`)
#echo ${profileuserList[@]}
profilenameList=(`grep path $wasroot/properties/profileRegistry.xml|grep $user | awk {'print $5'}| grep $user |cut -sd'"' -f2 | rev | cut -f1 -d'/'|rev`)
#echo ${profilenameList[@]}
cmdArgNo=$#

echo $arg1

banner()
{
  echo "Usage:"
  echo "1. Status               : This option would give the app server status for WAS profile [STARTED/STOPPED]."
  echo "2. Start                : This option would START app server for WAS profile."
  echo "3. Stop                 : This option would STOP app server for WAS profile "
  echo "4. Kill                 : This option would KILL app server for WAS profile "
  echo "5. Clear Logs           : This option would CLEAR app server LOG INFO for WAS profile "
  echo "6. Clear Logs N Cache   : This option would CLEAR app server LOG AND CACHE INFO for WAS profile "
  echo "7. List Profiles        : This option would LIST ALL WAS profile for the current user"
}

scrptmsg() {
        echo "Either invoke it from inside the root directory of a profile or provide profile Name/Alias"
        banner
        echo ""
        echo "was <option> [<profileName>[<profileAlias>]]"
        echo "option:"
        echo "          -start  : To start the application server"
        echo "          -stop   : To stop the application server"
        echo "          -status : To check status of the application server"
        echo "          -kill   : To  kill the instance of the application server"
        echo "          -list   : To list Profile Alias:: Profile Name : Profile Path"
        echo ""
}

chkArgs() {
#  echo "hi..$cmdArgNo"
  case $cmdArgNo in
        0) echo "Number of Arguments: $cmdArgNo"
           banner
           readOption
           ;;
        1) echo "Number of Arguments: $cmdArgNo"
	   validateArg
           ;;
        2) echo "Number of Arguments: $cmdArgNo"
	   validateArg
           ;;
        *) echo "Invalid Number of Arguments: $cmdArgNo"
           scrptmsg
           #exit 0
           ;;
  esac
}

validateArg() {
	
	if [ ! -z $arg1 ]
	then
		case $arg1 in
			-start) option="2"
				chkOption
				;;
			-stop)	option="3"
				chkOption
				;;
			-status) option="1"
                                chkOption
				;;
			-kill)  option="4"
                                chkOption
				;;
			-list)  option="7"
                                chkOption
				;;
                        -cl)    option="5"
                                chkOption
                                ;;
                        -clall) option="6"
                                chkOption
                                ;;
			*)
		
				;;
		esac
	fi

	if [ ! -z $arg2 ]
	then
		echo "COMING SOON..."
	fi
}

readOption()
{
  echo "Enter your option: "
  read option
  if [ -z $option ]
  then
        echo "Invalid option... do you want to continue: Y/N"
        read ans
        if [ -z $ans ]
        then
                echo "You did not enter any option...exiting..."
                exit 1
        else
                case $ans in
                [yY])   readOption
                        ;;
                [nN])   echo "Exiting..."
                        exit;;
                *)      echo "Invalid Option...exiting..."
                        exit;;
                esac
        fi
  else
        chkOption
  fi
}

chkOption() {

	if [ ! -z $option ]
	then
	        case $option in
        	        [1])    echo "Checking App server status..."
				profilepath
				wasstatus
	                        ;;
	                [2])    echo "Please wait while server is started..."
				profilepath
				wasstart
	                        ;;
        	        [3])    echo "Please wait while server is shuting down..."
				profilepath
				wasstop
                	        ;;
	                [4])    echo "You shouldn't HAVE KILLED ME!!!"
				profilepath
				waskill
        	                ;;

                	[223334])    	profilepath
	                 	        portinfo
		                        echo "Port Info"
        		                ;;

	                [5])    echo "Clear Logs"
        	                profilepath
                	        clearlog
                        	;;
	                [6])    echo "Clear Logs N Cache"
        	                profilepath
                	        clearcache
                        	;;
	                [7])    echo "Listing WAS profiles..."
        	                listprofiles
                	        ;;
	                *)
        	                ;;
	        esac
	fi

	


}

getProfileName() {
	#insideProfilePath=`grep $currentPath $wasroot/properties/profileRegistry.xml| awk {'print $5'}|cut -f2 -d'"'`

		echo "INside.."
		for p in ${profilenameList[@]}
		do
                	profilePathTemp=`grep $p $wasroot/properties/profileRegistry.xml| awk {'print $5'}|cut -f2 -d'"'`
			insideProfilePath=`echo $currentPath | grep $p`
			echo "Profile Match is....$insideProfilePath"
			if [ ! -z $insideProfilePath ]
			then
				profileName=$p
	                	break
			fi
		done	
}

readProfileName() {
        if [ $cmdArgNo -eq 0 ]
        then
                echo "Enter the Profile name for app server:"
                read profileName
        else
		echo "brrr.."
                getProfileName
		if [ -z $profileName ]
		then
			echo "SHOULD NOT DISPLAY THIS TEXT..BUG in script"
			scrptmsg
			exit 1
		fi
        fi
}

profilepath() {
	readProfileName

	profilePath=`grep $profileName $wasroot/properties/profileRegistry.xml| awk {'print $5'}|cut -f2 -d'"'`
	if [ -z $profilePath ]
	then
		echo "No such profile exists...exiting"
		exit 1
	fi
}

portinfo() {
	if [ -f $profilePath/logs/AboutThisProfile.txt ]
	then
		cat $profilePath/logs/AboutThisProfile.txt
		exit 1
	else
		echo "Default file for port Info $profilePath/logs/AboutThisProfile.txt does NOT exists...."
		echo "Please wait...Retrieving PORT information..."
	        >|$scriptHome/defaultNames.txt
	        sh $profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/getDefaultNames.py
	        sh $scriptHome/writeDefaultNames.sh
	        sh $profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/getports.py
	        sh $scriptHome/writeports.sh
	fi
}

clearlog() {
	if [ -z $profilePath ]
	then
		echo "No such profile exists...exiting"
        	exit 1
	else
		ffdclog="$profilePath/logs/ffdc"
		serverlog="$profilePath/logs/server1"

		if [ -z $serverlog ]
		then
                	echo "$serverlog directory does not exists"
	                exit 1
	
			if [ -z $ffdclog ]
			then
				echo "$ffdclog directory does not exists"
				exit 1
			fi
        	else
			if [ -f $serverlog/server1.pid ]
			then
				echo "Server is already started....making the logs as Zero bytes!!"
				>|$serverlog/SystemOut.log
				>|$serverlog/SystemErr.log
			else
				echo "Deleting the logs..."
				rm $serverlog/*.log
				rm $ffdclog/*.log
				rm $ffdclog/*.txt
				echo "Deletion completed..."
			fi
		fi
	fi
}

clearcache() {
	clearlog

	if [ -z $serverlog ]
	then
		echo "$serverlog directory does not exists"
	        exit 1
	fi
	
	if [ -f $serverlog/server1.pid ]
	then
		echo "Cache CANNOT be deleted while server is in STARTED STATE!"
		exit 1
	else
	  if [ -z $profilePath ]
	  then
	        echo "No such profile exists...exiting"
	        exit 1
	  else
		rm -rf $profilePath/temp/*
		rm -rf $profilePath/wstemp/*
		echo "Deletion completed..."
	  fi
	
	fi
}

listprofiles() {
	echo "Number of profiles for user: $user :${#profilenameList[*]}"
	
	for (( i=0; i < ${#profilenameList[*]}; i++ ))
	do
		profileAlias[i]="prf`expr $i + 1`"
	done
	echo ${profileAlias[@]}
	#       sh $wasroot/bin/manageprofiles.sh -listProfiles | cut -f2 -d'[' |cut -f1 -d']'

	if [ -f $scriptHome/profileAlias.sh ]
	then
		>|$scriptHome/profileAlias.sh
	fi

	chmod u+x $scriptHome/profileAlias.sh
	
	for (( i=0; i < ${#profilenameList[*]}; i++ ))
	do
	        profilePath=`grep ${profilenameList[i]} $wasroot/properties/profileRegistry.xml| awk {'print $5'}|cut -f2 -d'"'`
	        echo "`expr $i + 1`. ${profileAlias[i]} :: ${profilenameList[i]} : $profilePath"
		echo "alias ${profileAlias[$i]}='cd $profilePath'" >> $scriptHome/profileAlias.sh
		#`export alias ${profileAlias[$i]}='cd $profilePath'`
	done
	if [ -f $scriptHome/profileAlias.sh ]
	then
		chmod u+x $scriptHome/profileAlias.sh
		.  $scriptHome/profileAlias.sh
	else
		echo "Unable to create profile aliases..."
	fi
}

wasstatus() {
	sh $profilePath/bin/serverStatus.sh server1
}

wasstart() {
	sh $profilePath/bin/startServer.sh server1
}

wasstop() {
	sh $profilePath/bin/stopServer.sh server1
}

waskill() {
        pid=`ps -ef | grep $user | grep java| grep $profileName | awk {'print $2'}`
        if [ -z $pid ]
        then
                echo "$profileName is NOT UP...exiting!"
                exit 1
        else
                echo "$profileName process id is: $pid"
                echo "Are you sure you want to KILL the application server profile instance? Y/N [DEFAULT is: N]"
                read ans
                if [ -z $ans ]
                then
                        ans="N"
                else
                        case $ans in
                                [yY])   ans="Y"
                                        kill -9 $pid
                                        pid=`ps -ef | grep $user | grep IBM| grep $profileName | awk {'print $2'}`
                                        if [ -z $pid ]
                                        then
                                                echo "$profileName is killed...its process id is $pid [NULL]"
                                        else
                                                echo "Unable to Kill the process id...check the user!"
                                                echo "$profileName process id is: $pid"
                                        fi
                                        ;;
                                [nN])   ans="N"
                                        ;;
                                *)      echo "Invalid Option!"
                                        ;;
                        esac
                fi
        fi
}

chkArgs
