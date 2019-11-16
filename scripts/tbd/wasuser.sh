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

clear 		# clear the screen
echo -e "${bold}${red}WAS INSTALLATION AVAILABLE:${normal}"
echo -e "${bold}1. /home/was6/IBM/WebSphere/AppServer${normal}"
echo -e "${bold}2. /home/was6/IBM/WebSphere/AppServer1${normal}"
echo -e "${bold}${cyan_start}Enter the Was Installation: $cyan_stop${normal}"
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
serverlog=""
ffdclog=""
cmdArgNo=""
arg0=$0
arg1=$1
arg2=$2
arg3=$3
arg4=$4
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
#red=$(tput bold;tput setaf 1)
scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
adminScripts="$scriptHome/wasAdminScripts"
wasadminFlag=""
chkpid=""
psstatus=""
echo $arg1

colorNstyle(){

echo -e "\033[4mThis is underlined text.\033[0m"
echo -e '\E[37;44m'"\033[1mMAIN MENU\033[0m"
echo -e "${bold}$cyan_start Usage: $cyan_stop${normal}"
echo -e "\033[5m Enter your option: \033[0m"
echo -e "\033[1m  BOLD \033[2m DIM  \033[0m"
}

banner(){
  echo -n "						"
  echo -e '\E[37;44m'"\033[1m\033[4mMAIN MENU\033[0m\033[0m"
  echo "------------------------------------------------------------------------------------------------------------"
  echo 

  #echo -e "${bold}$cyan_start Usage: $cyan_stop${normal}"
  #echo "${bold}${red}"

  echo -e  '\E[33;44m'"1. Status              : This option would give the app server status for WAS profile [STARTED/STOPPED]."
  echo -e  '\E[33;44m'"2. Start               : This option would START app server for WAS profile."
  echo -e  '\E[33;44m'"3. Stop                : This option would STOP app server for WAS profile "
  echo -e  '\E[33;44m'"4. Kill                : This option would KILL app server for WAS profile "
  echo -e  '\E[33;44m'"5. Clear Logs          : This option would CLEAR app server LOG INFO for WAS profile "
  echo -e  '\E[33;44m'"6. Clear Logs N Cache  : This option would CLEAR app server LOG AND CACHE INFO for WAS profile "
  echo -e  '\E[33;44m'"7. List Profiles       : This option would LIST ALL WAS profile for the current user"
  echo -e  '\E[33;44m'"8. List Ports          : This option gets the PORT Information of the Profile...take some time to retrieve"
  echo -e  '\E[33;44m'"9. wasAdmin            : This option allows configuration and administration of Websphere App Server"
  echo -e  '\E[33;44m'"10. Restart and Clear  : This option would START app server for WAS profile."
  echo -e  '\E[33;44m'"    Logs N Cache"
  echo -e  '\E[33;44m'"11. TestInstaller      : This option allows TESTING LINUX INSTALLER by running Installer and deploying the application on WAS";tput sgr0
  echo -e  '\E[33;44m'"12. Perf SystemLog     : This option retrieves Performace related data from SystemOut.log if Request mertics is ON"
}

mainScriptUsage(){
  scrptmsg
  banner
  #exit -1
}

scrptmsg() {
	#echo -e "\033[5m Enter your option: \033[0m"
	echo "------------------------------------------------------------------------------------------------------------"
 	echo -e "${bold}$cyan_start Usage: $cyan_stop${normal}"
        echo -e "${bold}${red}		LINUX> was <option> [<profileName>[<profileAlias>]]${normal}"
        echo -e "${bold}${red}		LINUX> was -wasadmin [<adminOption>]]${normal}"
 	echo -e "${bold}$cyan_start<option>:$cyan_stop${normal}"
        echo -e "		\033[5m	-start  	: To start the application server \033[0m"
        echo -e "		\033[5m	-stop  		: To stop the application server\033[0m"
        echo -e "		\033[5m	-status 	: To check status of the application server\033[0m"
        echo -e "		\033[5m	-kill   	: To  kill the instance of the application server\033[0m"
        echo -e "		\033[5m	-list   	: To list Profile Alias:: Profile Name : Profile Path\033[0m"
        echo -e "		\033[5m	-rst    	: To restart the application server and clear log and cache\033[0m"
        echo -e "		\033[5m	-wasadmin	: Websphere Administration Panel\033[0m"
        echo -e "		\033[5m	-testinstaller	: Test Installer option for Installer testing\033[0m"
        echo -e "		\033[5m	-perf		: This option retrieves Performace related data from SystemOut.log if Request mertics is ON\033[0m"
	echo "------------------------------------------------------------------------------------------------------------"
	wsAdminUsage
	echo "------------------------------------------------------------------------------------------------------------"
}

wsAdminUsage() {
 #clear
 #echo "#######################################################"
 #echo "####           Welcome to WAS ADMIN CONSOLE        ####"
 #echo "#### This script is used to setup/configure WAS.   ####"
 #echo "#######################################################"
 echo -e "${bold}$cyan_start Usage: $cyan_stop${normal}"
 echo -e "${bold}${red}		LINUX> was -wasadmin [Flag] [-s]${normal}"
 #echo -e "${bold}${red}		LINUX> was -wasadmin -wsconfig [-s] [<advanceAdminOption>]${normal}"
 echo -e "${bold}$cyan_start [Flag]:$cyan_stop${normal}"
 echo -e "${bold}$cyan_start [ ] --> It means it's optional parameter!$cyan_stop${normal}"
 #echo -e "\033[1m  BOLD \033[2m DIM  \033[0m"`
 echo -e "		\033[1m 	-s 		     : For silent mode only. The installation script would use the pre-defined \033[0m"
 echo -e "		\033[1m			       was.config.properties file in the scripts directory. \033[0m"
 echo -e "		\033[1m	-h 		     : For Help  \033[0m"
 echo -e "		\033[1m	-wsconfig            : This option would create Managed Server and also setup the required JDBC and  \033[0m"
 echo -e "		\033[1m                       	JMS resources as per the application  configuration requirements.\033[0m"
 echo -e "		\033[1m	-app[iI]nstall       : This option would only deploy the Application[EAR/WAR].\033[0m"
 echo -e "		\033[1m	-app[pP]repare       : This option would create the EAR/WAR.\033[0m"
 echo -e "		\033[1m	-prf[dD]elete        : This option would delete Websphere profile.\033[0m"
 echo -e "		\033[1m	-app[uU]n[iI]nstall  : This option would un-deploy the Application \033[0m"
# echo "------------------------------------------------------------------------------------------------------------"
 wsAdminUsageExtended
}

wasAdminBanner() {
 #echo "1. Auto             : This option would Automate setup and application deployment"
 echo -n "                                             "
 echo -e '\E[37;44m'"\033[1m\033[4mWAS ADMINISTRATION MAIN MENU 1.0\033[0m\033[0m"
 echo "------------------------------------------------------------------------------------------------------------"

 echo -e  '\E[33;44m'"1. Help             : HELP option!!"
 echo -e  '\E[33;44m'"2. Admin            : This option would create Managed Server and also setup the required JDBC and "
 echo -e  '\E[33;44m'"                      JMS resources as per the application  configuration requirements."
 echo -e  '\E[33;44m'"3. Install          : This option would only deploy the Application[EAR/WAR]."
 echo -e  '\E[33;44m'"4. Prepare          : This option would create the EAR/WAR."
 echo -e  '\E[33;44m'"5. Delete           : This option would delete Websphere profile."
 echo -e  '\E[33;44m'"6. Setup            : This option would create and configure Websphere Admin server and custom profile."
 echo -e  '\E[33;44m'"7. UnInstall        : This option would un-deploy the Application";tput sgr0
}

wasAdminBannerExtended() {
  clear
  echo -n "                                             "
  echo -e '\E[37;44m'"\033[1m\033[4mWAS ADMIN SUB MENU 1.1\033[0m\033[0m"
  echo "------------------------------------------------------------------------------------------------------------"
  echo
  echo -e  '\E[33;44m'"1. JVM                 : Set JVM heap size and generic jvm parameters."
  echo -e  '\E[33;44m'"2. JDBC                : Create JDBC provider, DataSource, J2C jaas config."
  echo -e  '\E[33;44m'"3. Shared Lib          : Create Shared library and map it to the application."
  echo -e  '\E[33;44m'"4. DB Property         : Create/Modify Custom DataSource property."
  echo -e  '\E[33;44m'"5. Application Login   : Create JAAS application login.";tput sgr0
}

getwasAdminBannerExtended() {
         echo "Do you wish to continue[Y/N]:"
         read wsextans
         case $wsextans in
                [Yy])
                        echo "Advance Menu: Enter your Option: "
                        read extadminopt
                        extchkwasAdminOption
                        extwsadministrator
                        ;;
                [Nn])
                        echo "Advance Menu: User did not wish to continue with configuration!! Hence exiting"
                        ;;
                *)
                        echo "Advance Menu: Invalid option specified. Please re-run the script."
                        ;;
         esac
}

wsAdminUsageExtended() {
 	echo -e "${bold}$cyan_start Usage: $cyan_stop${normal}"
	echo -e "${bold}${red}		LINUX> was -wasadmin -wsconfig [-s] [<advanceAdminOption>]${normal}"
        echo -e "${bold}$cyan_start<advanceAdminOption>:$cyan_stop${normal}"
        echo -e "			\033[5m -s           : For silent mode only. The installation script would use the pre-defined\033[0m"
        echo -e "			\033[5m                was.config.properties file in the scripts directory.\033[0m"
        echo -e "			\033[5m -jvm         : Set JVM heap size and generic jvm parameters  \033[0m"
        echo -e "			\033[5m -jdbc        : Create JDBC provider, DataSource, J2C jaas config\033[0m"
        echo -e "			\033[5m -lib         : Create Shared library and map it to the application\033[0m"
        echo -e "			\033[5m -dbprop      : Create/Modify Custom DataSource property\033[0m"
        echo -e "			\033[5m -applnlogin  : Create JAAS application login\033[0m"
}

getwasAdminBanner() {
	 echo "Do you wish to continue[Y/N]:"
	 read wsans
	 case $wsans in 
		[Yy])
			echo "Enter your Option: "
			read adminopt
			chkwasAdminOption
			wsadministrator
               		;;
        	[Nn])
	               	echo "User did not wish to continue with configuration!! Hence exiting"
        	        ;;
	        *)
                	echo "Invalid option specified. Please re-run the script."
 			;;
	 esac
}

chkArgs() {
#  echo "hi..$cmdArgNo"
  case $cmdArgNo in
        0) echo "Number of Arguments: $cmdArgNo"
           mainScriptUsage
           readOption
           ;;
        1) echo "Number of Arguments: $cmdArgNo"
	   validateArg
           ;;
        2) echo "Number of Arguments: $cmdArgNo"
	   validateArg
           ;;
        3) echo "Number of Arguments: $cmdArgNo"
	   validateArg
           ;;
        4) echo "Number of Arguments: $cmdArgNo"
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
        	                -testinstaller)   	option="11"
							echo "Test Installer option is 11 now"
                        			        ;;
        	                -perf)   option="12"
					echo "Performance option is 12 now"
                        	        ;;
				*)	echo "Invalid Option..."
					;;
			esac
		fi
	fi
	optionArry=(1 2 3 4 5 6 7 8 10 11 12)
	# option do not require profile path
	# 7 is list option
	# 9 is wasadmin option
	# 11 is testinstaller option
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
				if [ -z $arg3 ]; then
					echo "Not in silent mode"
				else
					echo "Arg3: $arg3"
					echo "silent flag Enabled!!"
				fi
				if [ -z $arg4 ]; then
					echo "Not an advance USER!"
					chkwasAdminOption
					wsadministrator			
				elif [ ! -z $arg4 ]; then
					extchkwasAdminOption
					extwsadministrator			
				fi	
				break
			fi
		fi
	done

	if [ $cmdArgNo -eq "1" ]
	then
		echo
		#echo "ONE argument"
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
  #tput cup 1 2
  #echo -e "\033[5m ${bold}${red}Enter your option:${normal}  \033[0m"
  echo "${bold}${red}Enter your option:${normal}"
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
	clear	
	if [ ! -z $option ]
	then
	#	echo "Your option in code: $option"
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
                	        ;;
	                [1][0]) echo "WAS Administrator console..."
				wasrst
                	        ;;
	                [1][1]) echo "TEST INSTALLER..."
				testInstaller
                	        ;;
	                [1][2]) echo "Performace..."
				appPerfomance
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
		chkpid=`cat $serverlog/server1.pid`
		psstatus=`ps -ef | grep IBM| grep $chkpid`
		if [ -z $psstatus ];then
			echo "I was KILLED by you!!"
			rm  $serverlog/server1.pid
			echo "$serverlog/server1.pid is deleted!"
		fi
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
                	adminsPort=`grep "Administrative console secure port" $profilePath/logs/AboutThisProfile.txt | cut -f2 -d':'`
                	bootStrapPort=`grep "Bootstrap port" $profilePath/logs/AboutThisProfile.txt| cut -f2 -d':'`
                	httpPort=`grep "HTTP transport port" $profilePath/logs/AboutThisProfile.txt| cut -f2 -d':'`
                	httpsPort=`grep "HTTPS transport port" $profilePath/logs/AboutThisProfile.txt| cut -f2 -d':'`
		
			#echo ${bold}$red
			#echo ${bld}
			#echo -e "\033[4mThis is underlined text.\033[0m"
			adminPORT=`echo $adminPort | cut -f2 -d' '`
			#echo $adminPORT
			echo -e "${bold}${red}\033[4mConsole PORT${normal}\033[0m		http-${bold}${red}$adminPort${normal}   https-${bold}${red}$adminsPort${normal}"
			echo -e "${bold}${red}\033[4mApplication PORT\033[0m${normal}   	http-${bold}${red}$httpPort${normal}   https-${bold}${red}$httpsPort${normal}"
			echo -e "${bold}${red}\033[4mBootstrap PORT\033[0m		:${bold}${red}$bootStrapPort${normal}"
			echo -e "${bold}${red}Console URL${normal}		: ${bold}http://$ipaddress:$adminPORT/ibm/console/${normal}"
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
	retval=$?
        if [ $retval -eq 0 ]; then
		echo "I was terminated by the terminator!!"
	fi
	echo "Clearning JUNK!!"
	clearcache
	echo "Starting NOW...plz wait..N relax.."
	wasstart
}

appPerfomance() {
	profilepath
	echo $serverlog
	#SystemOut_09.08.17_18.03.33.log
	pageHit=(`cat $serverlog/SystemOut.log | grep PMRM0003I | grep detail= |cut -f15 -d' '`)
	timeElapsed=(`cat $serverlog/SystemOut.log | grep PMRM0003I | grep detail= |cut -f16 -d' '`)
	justTimeField=(`cat $serverlog/SystemOut.log | grep PMRM0003I | grep detail= |cut -f16 -d' '|cut -f2 -d'='`)
	strElapsed=(`cat $serverlog/SystemOut.log | grep PMRM0003I | grep detail= |cut -f16 -d' '|cut -f1 -d'='`)
	totalTime=0
	echo "Perfomance Data..."
	echo -n "Page HiT						"
	echo "Time Elasped [mili second]"

 	for (( i=0; i < ${#pageHit[*]}; i++ ))
        do
	#${bold}${red}
                #echo -e "${bold}`expr $i + 1`. ${pageHit[i]} :: ${red}${timeElapsed[i]}:${justTimeField[i]}${normal}"
                echo -e "${bold}`expr $i + 1`. ${pageHit[i]} :: ${red}${timeElapsed[i]}${normal}"
		if [ ! -z $strElapsed  ];then
			if [ $strElapsed = elapsed ];then
				#totalTime=`expr ${justTimeField[i]} + $totalTime`
				echo "$justTimeField"
				echo "$strElapsed"
			fi
		fi
	done
	echo -n "Total Time Elapsed: $totalTime"

	#echo "$pageHit::$timeElapsed"
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
	#echo "Inside chkwasAdminOption"
        if [ ! -z $adminopt ]
        then
                echo "Your Admin option code is: $adminopt"
                case $adminopt in
                        [1])    echo "WAS Admin Help option..."
				arg2="-h"
                                ;;
                        [2])    echo "Was Admin option...you will be redirected to SUB-MENU!"
				arg2="Admin"
                                ;;
                        [3])    echo "Please wait while we prepare server for application deployment..."
				arg2="Install"
                                ;;
                        [4])    echo "Please wait while we prepare the ear...[Deprecated: Instead use Update Insaller]"
				arg2="Prepare"
                                ;;
                        [5])    echo "You want to delete PROFILE!!"
				arg2="Delete"
                                ;;
                        [6])    echo "This option would create and configure Websphere Admin server and custom profile."
				arg2="Setup"
                                ;;
                        [7])    echo "This option would un-deploy the Application"
				arg2="UnInstall"
                                ;;
                        *)      echo "Invalid Option..."
                                ;;
                esac
		wasadminFlag=""
        fi

        if [ ! -z $arg3 ]
        then
		case $arg3 in
			-s)	echo "This is silent MODE!!"
				;;
			 *)	echo "Invalid Option"
				echo "Defaulted to -s option"
				$arg3="-s"
				;;
		esac
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
                	-prf[sS]etup)	        arg2="Setup"
	                                        ;;
        	        *)                      echo "Invalid Option.."
                	                        #exit -1
                        	                ;;
	      esac
	fi
}

extchkwasAdminOption() {
        echo "Inside  Advance...extchkwasAdminOption"
        if [ ! -z $extadminopt ]
        then
                echo "Your Admin option in code: $extadminopt"
                case $extadminopt in
                        [1])    echo "JVM option..."
                                arg4="-jvm"
                                ;;
                        [2])    echo "JDBC option..."
                                arg4="-jdbc"
                                ;;
                        [3])    echo "Shared Lib..."
                                arg4="-lib"
                                ;;
                        [4])    echo "DB Property..."
                                arg4="-dbprop"
                                ;;
                        [5])    echo "Application Login!!"
                                arg4="-appnlogin"
                                ;;
                        *)      echo "Advance Option: Invalid Option..."
                                ;;
                esac
        fi
}

wsadministrator() {
	#option="9"
	if [ -z $arg3 ]
	then 
		echo "Do you wish to run the option in silent mode? [Y/N]"
		read silentans
                if [ -z $silentans ]
                then
                        silentans="N"
                else
                        case $silentans in
                                [yY])   silentans="Y"
					arg3="-s"
                                        ;;
                                [nN])   silentans="N"
					echo "Executing your was admin option... $argr3"
					if [ $adminopt -eq "2" ]; then
						wasAdminBannerExtended
						getwasAdminBannerExtended
					else
						sh $adminScripts/wasAdminConfig.sh $arg3
					fi
                                        ;;
                                *)      echo "Invalid Option!"
                                        ;;
                        esac
                fi
	fi
	if [ ! -z $arg3 ]
	then
		echo "Arg3: $arg3"
		echo "Executing your was admin option in Silent mode... $arg3"
		if [ $adminopt -eq "2" ]; then
			wasAdminBannerExtended
			getwasAdminBannerExtended
		else
			sh $adminScripts/wasAdminConfig.sh $arg3 $arg2
		fi
	fi
}

extwsadministrator() {
	echo "Advance options for WAS administrator!"
        if [ -z $arg4 ]
        then
                echo "Do you wish to run the option in silent mode? [Y/N]"
                read silentans
                if [ -z $silentans ]
                then
                        silentans="N"
                else
                        case $silentans in
                                [yY])   silentans="Y"
                                        arg3="-s"
                                        ;;
                                [nN])   silentans="N"
                                        echo "Executing your was admin option... $arg4"
                                        echo "Amin option... $adminopt"
                                        #if [ $adminopt -eq "2" ]; then
					#	echo "No: IF"	
                                         #      wasAdminBannerExtended
                                          #     getwasAdminBannerExtended
                                        #else
					#	echo "No: else"
                                                sh $adminScripts/wasAdminConfig.sh $arg4
                                        #fi
                                        ;;
                                *)      echo "Invalid Option!"
                                        ;;
                        esac
                fi
        fi
        if [ ! -z $arg4 ]
        then
                echo "Arg4: $arg4"
                echo "Executing your was admin option... $arg4"
              #  if [ $adminopt -eq "2" ]; then
	       #         wasAdminBannerExtended
                #        getwasAdminBannerExtended
                #else
                        sh $adminScripts/wasAdminConfig.sh $arg4
                #fi
        fi
}

testInstaller() {
	sh testInstaller.sh
	echo ""
}

chkArgs
