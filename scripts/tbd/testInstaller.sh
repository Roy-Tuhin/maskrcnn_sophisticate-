#!/bin/bash


scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
adminScripts="$scriptHome/wasAdminScripts"
installerPath=""
installerName=""
installOption=""

installerBanner() {
 echo "#######################################################"
 echo "####            Welcome to Morgan Stanley          ####"
 echo "####             INSTALLER TEST VER 1.0            ####"
 echo "#######################################################"
 echo "Type of Installer Test: "
 echo "		1. Update Installer [Default Option]"
 echo "		2. Full Installer"
}

readinstallOption() {
 echo "Enter the type of Installer Test: "
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
        else
                echo "Default option: \"1. Update Installer\" is taken!"
                installOption=1
        fi

}
getInstallerInfo() {
	loop=1
        while [ $loop -lt 4 ]
        do
                echo "Enter Installer Path: [DEFAULT is `pwd` ]"
                read installerPath
                if [ -z $installerPath ]
                then
                        echo "Default current directory is taken..."
			installerPath=`pwd`
			#loop=`expr $loop + 1`
			break
                else
                        if [ ! -d $installerPath ]
                        then
                                echo "Directory $installerPath does not exist..."
                                echo "INVAILD Installer Path...STOP MAKING FUN...its serious business! :P "
				echo "..Try Again..."
				#exit -1
				loop=`expr $loop + 1`
			else
				echo "You have entered: $installerPath"
				break
                        fi
                fi
	        if [ $loop -eq 4 ]
        	then
	              	echo "You have reached the maximum retry limt. exiting......"
        	      	exit -1
  	        fi
	done
	
	echo "listing files in the Installer directory..."
	ls -l $installerPath
	loop=1
        while [ $loop -lt 4 ]
        do
                echo "Enter Installer Executable File Name: "
                read installerName
                if [ -z $installerName ]
                then
                        echo "Installer Name cannot be left empty!!!...Try Again..."
			loop=`expr $loop + 1`
                else
                        if [ ! -f $installerPath/$installerName ]
                        then
                                echo "Directory $installerPath/$installerName does not exist..."
                                echo "INVAILD Installer NAME...STOP MAKING FUN...its serious business! :P "
				echo "..Try Again..."
				#exit -1
				loop=`expr $loop + 1`
			else
				runinstaller
				break
                        fi
                fi
		if [ $loop -eq 4 ]
        	then
	              	echo "You have reached the maximum retry limt. exiting......"
        	      	exit -1
  	        fi
	done
}

runinstaller() {
	echo "You have entered: $installerName"
        if [ ! -x $installerPath/$installerName ]
        then
        	echo "Installer $installerName is not a executable...changing its permission.."
                chmod u+x $installerPath/$installerName
        fi
        echo "Running Installer....sit tight!!"
        $installerPath/$installerName
        retval=$?
        if [ $retval -eq 0 ]
        then
        echo "$1 Installation/Updation Complete!...."
        else
        	echo "$1 Installation/Updation FAILED !..."
                exit -1
        fi
	rundeploy
}

rundeploy() {
        echo "Do you want to apply another Update? [Y/N]"
        read updateans
        case $updateans in
                [Yy])
                        echo "Installating another Update for the application...!! "
			installOption=1 # to use update installer option
                        getInstallerInfo
                        ;;
                [Nn])
		        echo "Do you want to continue Deployment of the application? [Y/N]"
		        read deployans
                        ;;
                *)
                        echo "Invalid option specified. Please re-run the script."
                        exit -1
                        ;;
        esac
        case $deployans in
                [Yy])
                        echo "Continue deploying application on the server...Hold your breath!! "
                        sh $scriptHome/wasuser.sh -wasadmin
                        ;;
                [Nn])
                        echo "User did not wish to continue with configuration!! Hence exiting"
                        exit -1
                        ;;
                *)
                        echo "Invalid option specified. Please re-run the script."
                        exit -1
                        ;;
        esac
}

startInstaller() {
	installerBanner
	#rundeploy
	readinstallOption
	getInstallerInfo
}
startInstaller
