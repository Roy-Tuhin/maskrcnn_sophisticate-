#~/bin/bash
user=`whoami`

echo "Enter the Was Installation:"
echo "1. /home/was6/IBM/WebSphere/AppServer"
echo "2. /home/was6/IBM/WebSphere/AppServer1"
read wasoption
        if [ ! -z $wasoption ]
        then
                case $wasoption in
                        [1])    echo "App server root set to Option 1...."
				wasroot="/home/was6/IBM/WebSphere/AppServer"
                                ;;
                        [2])    echo "App server root set to Option 2...."
				wasroot="/home/was6/IBM/WebSphere/AppServer1"
				;;
			*)	echo "Default Option 2 is taken...."
				wasroot="/home/was6/IBM/WebSphere/AppServer1"
				;;
		esac
        else
                echo "Default Option 2 is taken...."
                wasroot="/home/was6/IBM/WebSphere/AppServer1"
        fi

#export $wasroot
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
adminopt=""
currentPath=`pwd`
profileuserList=(`grep path $wasroot/properties/profileRegistry.xml|grep $user | awk {'print $5'}| grep $user |cut -sd'"' -f2|cut -f3 -d'/'`)
#echo ${profileuserList[@]}
profilenameList=(`grep path $wasroot/properties/profileRegistry.xml|grep $user | awk {'print $5'}| grep $user |cut -sd'"' -f2 | rev | cut -f1 -d'/'|rev`)
insideProfilePath=""
profilePathTemp=""
#echo ${profilenameList[@]}
ipaddress=`/sbin/ifconfig -a | grep inet | grep -v '127.0.0.1' |awk '{ print $2}'| cut -f2 -d':'`
cmdArgNo=$#
bold=`tput bold`
bld=`tput smso`
nrml=`tput rmso`
reset=`tput reset`
#red=$(tput bold;tput setaf 1)
red=$(tput setaf 1)
normal=$(tput sgr0)
rev=$(tput rev)
adminScripts="/home/was6/BhaskarM/WASAdmin/localScripts/wasAdminScripts"
wasadminFlag=""
echo $arg1


banner(){
  echo "Usage:"
  echo "1. Status               : This option would give the app server status for WAS profile [STARTED/STOPPED]."
  echo "2. Start                : This option would START app server for WAS profile."
  echo "3. Stop                 : This option would STOP app server for WAS profile "
  echo "4. Kill                 : This option would KILL app server for WAS profile "
  echo "5. Clear Logs           : This option would CLEAR app server LOG INFO for WAS profile "
  echo "6. Clear Logs N Cache   : This option would CLEAR app server LOG AND CACHE INFO for WAS profile "
  echo "7. List Profiles        : This option would LIST ALL WAS profile for the current user"
  echo "8. List Ports        	: This option gets the PORT Information of the Profile...take some time to retrieve"
  echo "9. wasAdmin        	: This option allows configuration and administration of Websphere App Server"
  echo "10. Restart and Clear   : This option would START app server for WAS profile."
  echo "    Logs N Cache"                
  echo "11. TestInstaller       : This option allows TESTING LINUX INSTALLER by deploying the application on WAS"
}

mainScriptUsage(){
  echo "Usage:"
  echo "LINUX> InstallBancsApp.sh [-s] [Setup/Admin/Install/UnInstall]"
  echo "Flags:"
  #exit -1
}

scrptmsg() {
        echo "Either invoke it from inside the root directory of a profile or provide profile Name/Alias"
        banner
        echo ""
        echo "LINUX> was <option> [<profileName>[<profileAlias>]]"
        echo "LINUX> was -wasadmin [<adminOption>]]"
        echo "option:"
        echo "          -start  	: To start the application server"
        echo "          -stop  		: To stop the application server"
        echo "          -status 	: To check status of the application server"
        echo "          -kill   	: To  kill the instance of the application server"
        echo "          -list   	: To list Profile Alias:: Profile Name : Profile Path"
        echo "          -rst    	: To restart the application server and clear log and cache"
        echo "          -wasadmin     	: Websphere Administration Panel"
        echo ""
}

wsAdminUsage() {
 #clear
 #echo "#######################################################"
 #echo "####           Welcome to WAS ADMIN CONSOLE        ####"
 #echo "#### This script is used to setup/configure WAS.   ####"
 #echo "#######################################################"
 echo "Usage:"
 echo "LINUX>was -wasadmin [Flag]"
 echo "Flags:"
 echo "-s - For silent mode only. The installation script would use the pre-defined was.config.properties file in the scripts directory."
 echo "-h For Help"
 echo "-wsconfig            : This option would create Managed Server and also setup the required JDBC and "
 echo "                       JMS resources as per the application  configuration requirements."
 echo "-app[iI]nstall       : This option would only deploy the Application[EAR/WAR]."
 echo "-app[pP]repare       : This option would create the EAR/WAR."
 echo "-prf[dD]elete        : This option would delete Websphere profile."
 echo "-app[uU]n[iI]nstall  : This option would un-deploy the Application"
}

wasAdminBanner() {
 echo "1. Auto             : This option would Automate setup and application deployment"
 echo "2. Setup            : This option would create and configure Websphere Admin server and custom profile."
 echo "3. Admin            : This option would create Managed Server and also setup the required JDBC and "
 echo "                      JMS resources as per the application  configuration requirements."
 echo "4. Install          : This option would only deploy the Application[EAR/WAR]."
 echo "5. Prepare          : This option would create the EAR/WAR."
 echo "6. Delete           : This option would delete Websphere profile."
 echo "7. UnInstall        : This option would un-deploy the Application"
}

getwasAdminBanner() {
 echo "Do you wish to continue[Y/N]:"
 read wsans
 case $wsans in [Yy])
			echo "Enter your Option: "
			read adminopt
			chkwasAdminOption
                	;;
        [Nn])
                echo "User did not wish to continue with configuration!! Hence exiting"
                ;;
        *)
                echo "Invalid option specified. Please re-run the script."
                ;; esac
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
	echo "hi..inside validateArgs"
	echo "Arg2:  $arg2"
	echo "Admin Option:  $adminopt"
	

	if [ -z $adminopt ]
	then
		if [ ! -z $arg1 ]
		then
			case $arg1 in
				-start) option="2"
					;;
				-stop)	option="3"
					;;
				-status) option="1"
					;;
				-kill)  option="4"
					;;
				-list)  option="7"
					;;
                	        -cl)    option="5"
	                                ;;
        	                -clall) option="6"
                        	        ;;
	                        -was[aA]dmin) option="9"
					echo "was Admin Option"
                        	        ;;
        	                -rst)   option="10"
					echo "Restart option is 10 now"
                        	        ;;
				*)	echo "Invalid Option..."
					;;
			esac
		fi
	fi
	optionArry=(1 2 3 4 5 6 7 8 10)
	# option do not require profile path
	# 7 is list option
	# 9 is wasadmin option
	for opt in ${optionArry[@]}
	do
		if [ $option -eq $opt ]
		then
                	chkOption
			break
		elif [ $option -eq "9" ]
		then
			echo "Admin Option is:  $option"
			if [ -z $arg2 ]
			then
				echo "Argument check..admin.. Should be 1 arg.."
				echo "Arg1 : $arg1"
				echo "Arg2 : $arg2"
				chkOption
				break
			else
				echo "Argument check..admin.. Should be 1 arg.."
				echo "Arg1... : $arg1"
				echo "Arg2... : $arg2"
				wasadminFlag="$arg2"
				chkwasAdminOption
				#wsadministrator			
				break
			fi
		fi
	done

	if [ $cmdArgNo -eq "1" ]
	then
		echo "ONE argument"
	elif [ $cmdArgNo -eq "2" ]
	then
		echo "TWO argument"
		if [ ! -z $adminopt ]
		then
			arg2=$adminopt
			echo "arg2 is valid"
			echo "I'm here..it means..i'm invoked using command line argument"
		else
			echo "I'm confused"
			arg2=$2
		fi
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
                #exit 1
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
		echo "Your option in code: $option"
	        case $option in
        	        [1])    echo "Checking App server status..."
				wasstatus
	                        ;;
	                [2])    echo "Please wait while server is started..."
				wasstart
	                        ;;
        	        [3])    echo "Please wait while server is shuting down..."
				wasstop
                	        ;;
	                [4])    echo "You shouldn't HAVE KILLED ME!!! :("
				waskill
        	                ;;

                	[8])    	profilepath
	                 	        portinfo
		                        echo "Port Info"
        		                ;;

	                [5])    echo "Clear Logs"
                	        clearlog
                        	;;
	                [6])    echo "Clear Logs N Cache"
                	        clearcache
                        	;;
	                [7])    echo "Listing WAS profiles..."
        	                listprofiles
                	        ;;
	                [9])    echo "WAS Administrator console..."
				wasAdminBanner
				getwasAdminBanner
				wsadministrator
                	        ;;
	                [1][0])    echo "WAS Administrator console..."
				wasrst
                	        ;;
	                [1][1])    echo "TEST INSTALLER..."
				testInstaller
                	        ;;
	                *)	echo "Invalid Option..."
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
		#	echo "nanana....$profilePathTemp"
			
			#Some condition to check with the second option
			if [ -z $arg2 ]
			then
				insideProfilePath=`echo $currentPath | grep $p`
				#echo "I've only 1 argument"
				#echo "My Value is: $insideProfilePath"
			else
				insideProfilePath=`echo $arg2 | grep $p`
				#echo "I'm here..it means...I should have 2 arguments"
				#echo "Let's see...what I've..$insideProfilePath"
			fi
		#	echo "Profile Match is....$insideProfilePath"
			if [ ! -z $insideProfilePath ]
			then
				profileName=$p
	                	break
			fi
		done	
		if [ ! -z $insideProfilePath ]
		then
			echo "Profile Match is.... $insideProfilePath"
		else
			echo "NO profile with this name..TRY again!"
		fi
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
			#exit 1
		fi
        fi
}

profilepath() {
	readProfileName

	profilePath=`grep $profileName $wasroot/properties/profileRegistry.xml| awk {'print $5'}|cut -f2 -d'"'`
	if [ -z $profilePath ]
	then
		echo "No such profile exists...exiting"
		#exit 1
	else
                ffdclog="$profilePath/logs/ffdc"
                serverlog="$profilePath/logs/server1"
	fi
}

portinfo() {
	#if [ -f $profilePath/logs/AboutThisProfile.txt ]
	#then
	#	cat $profilePath/logs/AboutThisProfile.txt
		#exit 1
	#else
		echo "Default file for port Info $profilePath/logs/AboutThisProfile.txt does NOT exists...."
		echo "Please wait...Retrieving PORT information..."
	        >|$scriptHome/defaultNames.txt
	        sh $profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/getDefaultNames.py
	        sh $scriptHome/writeDefaultNames.sh
	        sh $profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/getports.py
	        sh $scriptHome/writeports.sh
	#fi
}

clearlog() {
	profilepath
	if [ -z $profilePath ]
	then
		echo "No such profile exists...exiting"
        	#exit 1
	else
		ffdclog="$profilePath/logs/ffdc"
		serverlog="$profilePath/logs/server1"

		if [ -z $serverlog ]
		then
                	echo "$serverlog directory does not exists"
	               #exit 1
	
			if [ -z $ffdclog ]
			then
				echo "$ffdclog directory does not exists"
				#exit 1
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
	profilepath
	clearlog

	if [ -z $serverlog ]
	then
		echo "$serverlog directory does not exists"
	        #exit 1
	fi
	
	if [ -f $serverlog/server1.pid ]
	then
		echo "Cache CANNOT be deleted while server is in STARTED STATE!"
		#exit 1
	else
	  if [ -z $profilePath ]
	  then
	        echo "No such profile exists...exiting"
	        #exit 1
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
	        #echo "`expr $i + 1`. ${profileAlias[i]} :: ${profilenameList[i]} : $profilePath"
	        echo -e "${bold}\033[36m`expr $i + 1`. ${profileAlias[i]} :: ${profilenameList[i]} : $profilePath\033[0m ${normal}"
		echo "alias ${profileAlias[$i]}='cd $profilePath'" >> $scriptHome/profileAlias.sh
        	if [ -f $profilePath/logs/AboutThisProfile.txt ]
	        then	
                	#cat $profilePath/logs/AboutThisProfile.txt
			#Administrative console port: 9075
			#Administrative console secure port: 9058
			#HTTP transport port: 9095
			#HTTPS transport port: 9458
			#Bootstrap port: 2824

                	adminPort=`grep "Administrative console port" $profilePath/logs/AboutThisProfile.txt | cut -f2 -d':'`
                	bootStrapPort=`grep "Bootstrap port" $profilePath/logs/AboutThisProfile.txt| cut -f2 -d':'`
                	httpPort=`grep "HTTP transport port" $profilePath/logs/AboutThisProfile.txt| cut -f2 -d':'`
		
			#echo ${bold}$red
			#echo ${bld}
			adminPORT=`echo $adminPort | cut -f2 -d' '`
			#echo $adminPORT
			echo "${bold}${red}Console PORT		:$adminPort"
			echo "Bootstrap PORT		:$bootStrapPort"
			echo "Application PORT	:$httpPort"
			echo "Console URL		: http://$ipaddress:$adminPORT/ibm/console/${normal}"
			#echo $normal
			echo " "
		#	echo -e "\033[36mHello\033[0m"
		else
			echo "${bold}AboutThisProfile.txt file NOT available!!${normal} Check the ports separately"
			echo " "
		fi
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
	profilepath
	sh $profilePath/bin/serverStatus.sh server1
}

wasstart() {
	profilepath
	sh $profilePath/bin/startServer.sh server1
}

wasstop() {
	profilepath
	sh $profilePath/bin/stopServer.sh server1
}

wasrst() {
	profilepath
	echo "Restart Server Test...first call is to ME"
	if [ -f $serverlog/server1.pid ]
	then
		echo "I'm already started!"
		wasstop
	fi
	echo "Clearning JUNK!!"
	clearcache
	echo "Starting NOW...plz wait..N relax.."
	wasstart
}

waskill() {
	profilepath
        pid=`ps -ef | grep $user | grep java| grep $profileName | awk {'print $2'}`
        if [ -z $pid ]
        then
                echo "$profileName is NOT UP...exiting!"
                #exit 1
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
chkwasAdminOption() {
	echo "Inside chkwasAdminOption"
        if [ ! -z $adminopt ]
        then
                echo "Your Admin option in code: $option"
 echo "1. Auto             : This option would Automate setup and application deployment"
 echo "2. Setup            : This option would create and configure Websphere Admin server and custom profile."
 echo "3. Admin            : This option would create Managed Server and also setup the required JDBC and "
 echo "                      JMS resources as per the application  configuration requirements."
 echo "4. Install          : This option would only deploy the Application[EAR/WAR]."
 echo "5. Prepare          : This option would create the EAR/WAR."
 echo "6. Delete           : This option would delete Websphere profile."
 echo "7. UnInstall        : This option would un-deploy the Application"

                case $adminopt in
                        [1])    echo "Checking App server status..."
				arg2="-h"
                                ;;
                        [2])    echo "Please wait while server is started..."
				arg2="Admin"
                                ;;
                        [3])    echo "Please wait while server is shuting down..."
				arg2="Install"
                                ;;
                        [4])    echo "You shouldn't HAVE KILLED ME!!! :("
				arg2="Prepare"
                                ;;
                        [5])    echo "Clear Logs"
				arg2="Delete"
                                ;;
                        [6])    echo "Clear Logs N Cache"
                                ;;
                        [7])    echo "Listing WAS profiles..."
                                ;;
                        *)      echo "Invalid Option..."
                                ;;
                esac
		wasadminFlag=""
        fi

        if [ ! -z $wasadminFlag ]
        then
        	case $wasadminFlag in
                	-h)                     arg2="-h"
	                                        ;;
        	        -wsconfig)              arg2="Admin"
                	                        ;;
	                -app[iI]nstall)         arg2="Install"
        	                                ;;
                	-app[pP]repare)         arg2="Prepare"
                        	                ;;
	                -app[uU]n[iI]nstall)    arg2="UnInstall"
        	                                ;;
                	-prf[dD]elete)          arg2="Delete"
	                                        ;;
        	        *)                      echo "Invalid Option.."
                	                        #exit -1
                        	                ;;
	      esac
	fi
}

wsadministrator() {
	#option="9"
	echo "Executing your was admin option... $arg2"
	sh $adminScripts/InstallBancsApp.sh $arg2
}

installerBanner() {
 echo "#######################################################"
 echo "####   	       Welcome to Morgan Stanley 	  ####"
 echo "#### 		TEST INSTALLER VERSION		  ####"
 echo "#######################################################"
 echo "Enter the type of Installer Test: "
 echo "1. Update Installer"
 echo "2. Full Installer"
 read installOption
        if [ ! -z $installOption ]
        then
                case $installOption in
                        [1])    echo "Option 1...test for Update Installer."
                                ;;
                        [2])    echo "Option 2...test for Full Installer."
                                ;;
                        *)      echo "Invalid option...Better Luck Next Time!! :P"
                                ;;
                esac
        fi

}
getInstallerInfo() {
	echo " "

}
testInstaller() {

	echo ""

}

chkArgs
