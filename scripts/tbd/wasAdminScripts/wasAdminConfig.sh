#!/bin/bash

trap exitsignal 1 2 3 4

# This script is used for generating the Bancs Installation Property File for Websphere 6.x
managedssl=1
ipaddress=""
host=""
#ipaddress=`/sbin/ifconfig -a | grep inet | grep -v '127.0.0.1' |awk '{ print $2}'`
ipaddress=`/sbin/ifconfig -a | grep inet | grep -v '127.0.0.1' |awk '{ print $2}'| cut -f2 -d':'`
host=`hostname`
scriptHome="/home/was6/BhaskarM/WASAdmin/localScripts"
adminScripts="$scriptHome/wasAdminScripts"
installerPropertyFile=`cat $scriptHome/wasAdminScripts/testInstaller.properties | grep propertyFile= |grep -v "#" | cut -f2 -d'='`

export LOCALIP=$ipaddress
export LOCALHOSTNAME=$host
echo "IP of this System is: $ipaddress"
echo "Hostname of this System is: $host"
echo "Inside Admin script.... was root from main script is: $wasroot"
exitsignal()
{
 echo "User Interrupt received.. Exiting."
 stty -echo
 stty echo
 exit -1
}

#default properties
appDepMode="S"
defaultNodeAndCell="Y"
dbType="D"
DBMSMode="S"
db_nodes=1;
log_mode="E"

#Mandatory/Optional properties
wasRoot=""
customProfileName=""
securityEnabled=""
installerPropertyFile=""
customNodeName=""
cellName=""
installDir=""
appHome=""
appName=""
archiveFileName=""
deploymentDir=""
logDir=""
initialHeapSize=""
maxHeapSize=""
jvmArgs=""
dbType=""

arg0=$0
arg1=$1
arg2=$2

checkip()
{
  class=""
  ip1=0;
  ip2=0;
  ip3=0;
  ip4=0;
  ip1=`echo $ip | cut -f1 -d"."`
  ip2=`echo $ip | cut -f2 -d"."`
  ip3=`echo $ip | cut -f3 -d"."`
  ip4=`echo $ip | cut -f4 -d"."`
  if [ $ip1 -ge 0 -a $ip1 -le 127 -a $ip2 -ge 0 -a $ip2 -le 255 -a $ip3 -ge 0 -a $ip3 -le 255 -a $ip4 -ge 0 -a $ip4 -le 255 ]
  then
    class="A"
  elif [ $ip1 -ge 128 -a $ip1 -le 191 -a $ip2 -ge 0 -a $ip2 -le 255 -a $ip3 -ge 0 -a $ip3 -le 255 -a $ip4 -ge 0 -a $ip4 -le 255 ]
  then
    class="B"
  elif [ $ip1 -ge 192 -a $ip1 -le 223 -a $ip2 -ge 0 -a $ip2 -le 255 -a $ip3 -ge 0 -a $ip3 -le 255 -a $ip4 -ge 0 -a $ip4 -le 255 ]
  then
    class="C"
  elif [ $ip1 -ge 224 -a $ip1 -le 239 -a $ip2 -ge 0 -a $ip2 -le 255 -a $ip3 -ge 0 -a $ip3 -le 255 -a $ip4 -ge 0 -a $ip4 -le 255 ]
  then
    class="D"
  else
   class="I"
  fi

}


select="";
silent="N";
currentPath=`pwd`

while getopts sh?  optn
do
        case $optn in
                s)
			echo "I'm silent!"
			echo "Arg1: $arg1,Arg2: $arg2,Arg3: $arg3"
                        shift;
                        #bannermsg=$1
                        #InstallBanner
                        if [ ! -f $scriptHome/wasAdminScripts/was.config.properties ]
                        then
                                echo "Pre Defined Bancs Properties file not found.. Invalid option "-s" specified"
                                exit 1
                        else
                                silent="Y";
                        fi 
			echo "Now: $1 "
			arg1=$1
			;;
                [Hh])	echo "I'm in Admin Help option!!"
			echo "Arg1: $arg1,Arg2: $arg2,Arg3: $arg3"
                        #Usage
                        ;;
                *)	echo "You have given some strange option that I don't understand!!"
			echo "Arg1: $arg1,Arg2: $arg2,Arg3: $arg3"
			startScript
                        ;;
                esac
done

startScript() {
	#if [ $silent != "Y" -a  $1 != "Prepare" -a $1 != "Delete" -a $1 != "Uninstall"  ]
echo "In startScript: $1 and arg1: $arg1"
	if [ $silent != "Y" ]
	then
		#echo "coming Soon..."
		echo "1. Set Mandatory Properies: "
		setMandatoryProperty
		echo "2. Set Default Properies: "
		setDefaultProperty
		echo "3. Set Optional Properies: "
		setOptionalProperty
		echo "4. Set Installer Properies: "
		setInstallerProperty
		echo "5. Set JVM Properies: "
		setJVMProperty
		echo "6. Set Database Properies: "
		setDBProperty

		createPropertyFile

		chkWasAdminOption
	else
		chkWasAdminOption
	fi
	
}

setMandatoryProperty() {
	loop=1
	while [ $loop -lt 4 ]
	do
		echo "Enter the IBM Websphere Installation Root directory path. [Mandatory]"
        	read wasRoot
	        if [ -z "$wasRoot" ]
        	then
	        	echo "IBM Websphere Installation Root directory path is not set. Please try again."
		        loop=`expr $loop + 1`
	        else
        	        if [ ! -d "$wasRoot" -o ! -w "$wasRoot" ]
                	then
	           	     echo "Directory $wasRoot does not exist or is not Writable.."
        	             echo "Please create the directory or alter permissions on $wasRoot and retry.."
	        	     exit 1
	                fi
        	        if [ ! -d "$wasRoot/bin" -o ! -d "$wasRoot/java/bin" ]
                	then
                		echo "Directory $wasRoot/bin or $wasRoot/java/bin  does not exist."
	                	echo "It may be because Websphere is not installed on your system. Please Install Websphere."
        	        	exit 1
               		fi
	             	break
	       fi
	       if [ $loop -eq 4 ]; then
		       echo "You have reached the maximum retry limt. exiting......"
	               exit 1
	       fi
	done

        loop=1
        while [ $loop -lt 4 ]
        do
        	echo "Enter the Websphere Profile Name in which application server/s will be created/reside. [Mandatory]:"
        	read customProfileName
	        if [ -z "$customProfileName" ]; then
    	            echo "Websphere Profile Name not set. Please try again."
        	    loop=`expr $loop + 1`
	        else
        		break
	        fi
          	if [ $loop -eq 4 ]; then
 	 	       echo "You have reached the maximum retry limt. exiting......"
              	       exit 1
 	        fi
       done

       loop=1
       while [ $loop -lt 4 ]
       do
          echo "Enter whether admin security is enabled or disabled. Valid values [Y] for Yes [N] for No. [DEFAULT is: N]"
          read securityEnabled
          if [ -z "$securityEnabled" ]
          then
            echo "WebSphere admin security flag is set to DEFAULT option."
            securityEnabled="N"
            break
           else
                case $securityEnabled in
                    [yY])
                      securityEnabled="Y"
                      break ;;
                    [nN])
                      securityEnabled="N"
                      break ;;
                    *)
                      echo "Invalid Option Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done
}

setOptionalProperty() {
        if [ $securityEnabled = "Y" -o $securityEnabled = "y" ]
        then
                loop=1
                while [ $loop -lt 4 ]
                do
                  echo "Enter the Admin User Name:"
                  read adminUserName
                  if [ -z "$adminUserName" ]
                  then
                    echo "Admin user name is not set. Please try again."
                    loop=`expr $loop + 1`
                   else
                     break
                  fi
                  if [ $loop -eq 4 ]
                  then
                      echo "You have reached the maximum retry limt. exiting......"
                      exit 1
                  fi
                done

                loop=1
                while [ $loop -lt 4 ]
                do
                  echo "Enter the Admin Password:"
                  stty -echo
                  read adminPassword
                  stty echo
                  echo "\r"
                  if [ -z "$adminPassword" ]
                  then
                    echo "Admin password is not set. Please try again."
                    loop=`expr $loop + 1`
                   else
                     break
                  fi
                  if [ $loop -eq 4 ]
                  then
                      echo "You have reached the maximum retry limt. exiting......"
                exit 1
                fi
                done
        fi

        if [ $defaultNodeAndCell = "N" -o $defaultNodeAndCell = "n" ]; then
        	loop=1
 	       	echo "Default option is : $defaultNodeAndCell"
               	while [ $loop -lt 4 ]
	       	do
               		echo "Enter Name of the Node where Custom profiles' Servers resides: "
            		read customNodeName
	                if [ -z "$customNodeName" ]
             		then
			        echo "Node name is not set. Please try again."
			        loop=`expr $loop + 1`
	                else
           			break
		        fi
	               if [ $loop -eq 4 ]
           	       then
                       		stty -echo
		                read adminPassword
                		stty echo
		                echo "\r"
                		if [ -z "$adminPassword" ]
		                then
                			echo "Admin password is not set. Please try again."
			                loop=`expr $loop + 1`
		                else
                			break
		                fi
                		if [ $loop -eq 4 ]
		                then
                			echo "You have reached the maximum retry limt. exiting......"
			                exit 1
		                fi
		      fi
	     	done
        	loop=1
             	while [ $loop -lt 4 ]
             	do
             	     echo "Enter Name of the Node where Custom profiles' Servers resides: "
		     read customNodeName
	             if [ -z "$customNodeName" ]
          	     then
	 	            echo "Node name is not set. Please try again."
		            loop=`expr $loop + 1`
	             else
        		     break
	             fi
         	     if [ $loop -eq 4 ]
	             then
         		     echo "You have reached the maximum retry limt. exiting......"
	                     exit 1
	             fi
          	done
        	loop=1
          	while [ $loop -lt 4 ]
          	do
        	  	echo "Enter Name of the Cell where admin server profile and custom profile configurations are kept: "
		  	read cellName
 	          	if [ -z "$cellName" ]
	           	then
        		  	echo "Cell name is not set. Please try again."
	               		loop=`expr $loop + 1`
	                else
               	 	 	break
	                fi
        	 	if [ $loop -eq 4 ]
	          	then
		     		echo "You have reached the maximum retry limt. exiting......"
  	                	exit 1
           		fi
        	done
	fi

}

setInstallerProperty() {
	loop=1
        while [ $loop -lt 4 ]
        do
        	echo "Enter the Installation Directory for the application."
	        read installDir
        	if [ -z "$installDir" ]; then
			echo "Installation Directory cannot be left empty!!"
	                loop=`expr $loop + 1`
		else
			installerPropertyFile=`ls $installDir/*.properties | rev| cut -f1 -d'/' |rev`
			break
        	fi
	        if [ $loop -eq 4 ]
                then
                	echo "You have reached the maximum retry limt. exiting......"
                        exit 1
                fi
	done
	
	echo "PropertyFile....$installerPropertyFile"
        if [ -z "$installerPropertyFile" ]; then
                echo "This should not happen...NO property file found.. Might be INTERNAL ERROR...!!"
                exit 1
	else
		appName=`cat $installDir/$installerPropertyFile | grep appName= | grep -v "#" | cut -f2 -d'='`
        	echo "Application Name to be Installed is:"
	        if [ -z "$appName" ]
        	then
                	echo "This should not happen...NO APPLICATION NAME... Might be INTERNAL ERROR...!!"
	                exit 1
        	fi
	fi

	case $appName in
		BancsEAR)
			appHome=$installDir/HUB
			archiveFileName="BancsEAR.ear"
			deploymentDir=$installDir/Properties/HUB
			logDir="$installDir/logs/HUB"
			;;
		*)	echo "Invalid Application...please ask your System Administrator to support installation of NEW Application"
			exit 1
			;;
	esac

        if [ -z "$appHome" ]; then
	        echo "This should not happen...NO APPLICATION NAME... Might be INTERNAL ERROR...!!"
        	exit 1
        fi

        if [ ! -d "$appHome" -o ! -w "$appHome" ]
        then
        	echo "Directory $appHome does not exist or is not Writable.."
	        echo "Please create the directory or alter permissions on $appHome and retry.."
        	exit 1
        else
        	export appHome
        fi

        if [ -z "$archiveFileName" ]
        then
	        echo "This should not happen...NO ARCHIVE FILE NAME... Might be INTERNAL ERROR...!!"
        	exit 1
        fi

	loop=1
        while [ $loop -lt 4 ]
        do
        	#echo "Please enter the path for Deployment Directory: [DEFAULT:$installDir/Properties/HUB]:"
	        #read deploymentDir
        	if [ -z "$deploymentDir" ]
	        then
        		deploymentDir="$installDir/Properties/HUB"
		        echo "Deployment DIR: $deploymentDir"
		        break;
	        fi
        	if [ ! -d "$deploymentDir" -o ! -w "$deploymentDir" ]
	        then
        		echo "Directory $deploymentDir does not exist or is not Writable.."
		        echo "Please copy the properties directory at $appHome path and retry.."
		        echo "Please enter the path for Deployment Directory: [DEFAULT:$installDir/Properties/HUB]:"
		        deploymentDir=""
		        read deploymentDir
		        loop=`expr $loop + 1`
	        else
        		break;
	        fi
        	if [ $loop -eq 4 ]
	        then
        		echo "You have reached the maximum retry limt. exiting......"
		        exit 1
	        fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
        	#echo "Please enter the path for Log Directory(please create the directory and give write permissions to the User Id used for installation): [DEFAULT:$installDir/logs/HUB]:"
	        #read logDir
        	if [ -z "$logDir" ]
	        then
        		logDir="$installDir/logs/HUB"
		        break;
	        fi
        	if [ ! -d "$logDir" -o ! -w "$logDir" ]
	        then
        		echo "Directory $logDir does not exist or is not Writable.."
		        echo "Please create the directory or alter permissions on $appHome and retry.."
		        echo "Please enter the path for Log Directory(please create the directory and give write permissions to the User Id used for installation): [DEFAULT:$installDir/logs/HUB]:"
		        logDir=""
		        read logDir
			loop=`expr $loop + 1`
	        else
        		break;
	        fi
        	if [ $loop -eq 4 ]
	        then
        		echo "You have reached the maximum retry limt. exiting......"
		        exit 1
	        fi
        done

}

setJVMProperty() {
        loop=1
        while [ $loop -lt 4 ]
        do
          echo "Enter Initial heap size(Positive Integer value in MB) for JVM. [Default:512MB]"
          read initialHeapSize
          if [ -z "$initialHeapSize" ]
          then
            initialHeapSize=512
            break
          else
                case $initialHeapSize in
                    [0-9]* )
                      initialHeapSize=$initialHeapSize
                      if [ $initialHeapSize -lt 0 -o $initialHeapSize -gt 2048 ]
                      then
                        echo "Invalid Value Entered. Please try again."
                        loop=`expr $loop + 1`
                      else
                        break
                      fi
                      ;;
                    *)
                      echo "Invalid Value Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
          fi
          if [ $loop -eq 4 ]
          then
            echo "You have reached the maximum retry limt. exiting......"
            exit 1
         fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          echo "Enter Maximum heap size(Positive Integer value in MB) for JVM. [Default:1024MB]"
          read maxHeapSize
          if [ -z "$maxHeapSize" ]
          then
            maxHeapSize=1024
            break
          else
                case $maxHeapSize in
                    [0-9]* )
                      maxHeapSize=$maxHeapSize
                      if [ $maxHeapSize -lt $initialHeapSize -o $maxHeapSize -gt 2048 ]
                      then
                        echo "Invalid Value Entered. Maximum Heap Size cannot be greater than 2048MB or less than initial heap size. Please try again."
                        loop=`expr $loop + 1`
                      else
                        break
                      fi
                      ;;
                    *)
                      echo "Invalid Value Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
          fi
          if [ $loop -eq 4 ]
          then
            echo "You have reached the maximum retry limt. exiting......"
            exit 1
         fi
        done

        echo "Enter JVM Startup Arguments:[DEFAULT is: -XX:MaxPermSize=1024m -XX:MaxNewSize=512m -XX:NewSize=512m -Xss1024k]"
        read jvmArgs
        if [ -z "$jvmArgs" ]
        then
            jvmArgs="-XX:MaxPermSize=1024m -XX:MaxNewSize=512m -XX:NewSize=512m -Xss1024k"
            echo "JVM Startup Arguments is set to DEFAULT optioin."
        fi
}

setDefaultProperty() {
	appDepMode="S"
	wasNDVersion="N"
	profileType="A"
	defaultNodeAndCell="Y"
	standAloneManagedServerListenAddress=$ipaddress

        loop=1
        while [ $loop -lt 4 ]
        do
        #echo "Enter Application Deployment Mode [C: CLUSTER], [S: STANDALONE].[DEFAULT is:S]"
        #read appDepMode
         if [ -z "$appDepMode" ]
          then
            echo "Application Deployment Mode is set to DEFAULT option."
            appDepMode="S"
            break
          else
            case $appDepMode in
            [cC])
              appDepMode="C"
              break ;;
            [sS])
              appDepMode="S"
              break ;;
            *)
              echo "Invalid Option Entered. Please try again."
              loop=`expr $loop + 1` ;;
            esac
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          #echo "Enter whether the WebSphere Application Installation is Netword Deployment Version."
          #echo "[Y] for yes, [N ]for No. [DEFAULT is: N]"
          #read wasNDVersion
          if [ -z "$wasNDVersion" ]
          then
            echo "WebSphere Application Installation is set to DEFAULT option."
            wasNDVersion="N"
            break
           else
                case $wasNDVersion in
                    [yY])
                      wasNDVersion="Y"
                      break ;;
                    [nN])
                      wasNDVersion="N"
                      break ;;
                    *)
                      echo "Invalid Option Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          #echo "Enter the Type of profile to be created:[DEFAULT is: A]"
          #echo "[A] for AppServer"
          #echo "[B] for both custom and deployment Manager"
          #echo "[C] for custom profile"
          #echo "[D] for deployment manager profile"
          #read profileType
          if [ -z "$profileType" ]
          then
            echo "Type of profile for WebSphere Application Installation is set to DEFAULT option."
            profileType="A"
            break
           else
                case $profileType in
                    [aA])
                      profileType="A"
                      break ;;
                    [bB])
                      profileType="B"
                      break ;;
                    [cC])
                      profileType="C"
                      break ;;
                    [dD])
                      profileType="D"
                      break ;;
                    *)
                      echo "Invalid Option Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
                 echo $profileType
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          #echo "Enter whether Use system generated cell and node names. Valid values [Y] for Yes [N] for No."
          #echo "IF [Y], custom cell and node names will be ignored while profile creation. [DEFAULT is: Y]"
          #read defaultNodeAndCell
          if [ -z "$defaultNodeAndCell" ]
          then
            echo "Default Cell and Node name flag is set to DEFAULT option."
            defaultNodeAndCell="Y"
            break
           else
                case $defaultNodeAndCell in
                    [yY])
                      defaultNodeAndCell="Y"
                      break ;;
                    [nN])
                      defaultNodeAndCell="N"
                      break ;;
                    *)
                      echo "Invalid Option Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

	case $appDepMode in
	[cC]* )
	  loop=1
	  while [ $loop -lt 4 ]
	  do
	    echo "Enter the Name of the Cluster where Bancs Online application deployment needs to be targeted: "
	    read clusterName
	    if [ -z "$clusterName" ]
	    then
	      echo "Name of the Cluster where Bancs Online application deployment needs to be targeted not set. Please try again."
	      loop=`expr $loop + 1`
	     else
	       break
	    fi
	    if [ $loop -eq 4 ]
	    then
		echo "You have reached the maximum retry limt. exiting......"
		exit 1
	    fi
	  done

	  loop=1
	  while [ $loop -lt 4 ]
	  do
	    echo "Enter the Listen Address of the Cluster where Bancs Online application deployment is to be targeted: "
	    read clusterAddress
	    if [ -z "$clusterAddress" ]
	    then
	      echo "Listen Address of the Cluster where Bancs Online application deployment is to be targeted is not set. Please try again."
	      loop=`expr $loop + 1`
	     else
	       break
	    fi
	    if [ $loop -eq 4 ]
	    then
		echo "You have reached the maximum retry limt. exiting......"
		exit 1
	    fi
	  done

	  loop=1
	  while [ $loop -lt 4 ]
	  do
	    echo "Enter the Listen Port of the Cluster where Bancs Online application deployment is to be targeted: "
	    read clusterPort
	    if [ -z "$clusterPort" ]
	    then
	      echo "Listen Port of the Cluster where Bancs Online application deployment is to be targeted is not set. Please try again."
	      loop=`expr $loop + 1`
	     else
	       if [ $clusterPort -gt 1024 -a $clusterPort -le 65536 ]
	       then
	         break
	       else
	         echo "Invalid Listen Port of the Cluster entered kindly re enter"
	         loop=`expr $loop + 1`
	       fi
	    fi
	    if [ $loop -eq 4 ]
	    then
		echo "You have reached the maximum retry limt. exiting......"
		exit 1
	    fi
	  done

	  loop=1
	  while [ $loop -lt 4 ]
	  do
	    echo "Enter the number of Managed Servers that are part of the Cluster: "
	    read managedServerListCount
	    if [ -z "$managedServerListCount" ]
	    then
	      echo "Number of Managed Servers that are part of the Cluster is not set. Please try again."
	      loop=`expr $loop + 1`
	     else
	       if [ $managedServerListCount -gt 0 ]
	       then
	        break
	       else
	        echo "Invalid number kindly re enter"
	        loop=`expr $loop + 1`
	       fi
	    fi
	    if [ $loop -eq 4 ]
	    then
		echo "You have reached the maximum retry limt. exiting......"
		exit 1
	    fi
	  done

	  srvrCountLoop=1;
	  while [ $srvrCountLoop -le $managedServerListCount ]
	  do
	      loop=1
	      while [ $loop -lt 4 ]
	      do
                  echo "Enter the Name For Server $srvrCountLoop :"
                  read managedServerList
                  if [ -z "$managedServerList" ]
         	  then
         	    echo "Managed Server Name for Server $srvrCountLoop is not set. Please try again."
         	    loop=`expr $loop + 1`
         	   else
         	     break
         	  fi
         	  if [ $loop -eq 4 ]
         	  then
                      	echo "You have reached the maximum retry limt. exiting......"
         		exit 1
         	  fi
	      done

	      loop=1
	      while [ $loop -lt 4 ]
	      do
                  echo "Enter Host For Server $srvrCountLoop :"
                  read mngdSrvrHost
                  if [ -z "$mngdSrvrHost" ]
         	  then
         	    echo "Managed Server Host for Server $srvrCountLoop is not set. Please try again."
         	    loop=`expr $loop + 1`
         	   else
         	     break
         	  fi
         	  if [ $loop -eq 4 ]
         	  then
                      	echo "You have reached the maximum retry limt. exiting......"
         		exit 1
         	  fi
		done

	        loop=1
                while [ $loop -lt 4 ]
                do
                       echo "Enter Port For Server $srvrCountLoop:"
                       read mngdSrvrPort
           	       if [ -z "$mngdSrvrPort" ]
         	       then
         	         echo "Managed Server Port for Server $srvrCountLoop is not set. Please try again."
         	         loop=`expr $loop + 1`
         	        else
         	         if [ $mngdSrvrPort -gt 1024 -a $mngdSrvrPort -le 65536 ]
	                 then
	                    break
	                 else
	                    echo "Invalid Listen Port For Server $srvrCountLoop entered kindly re enter"
	                    loop=`expr $loop + 1`
	                 fi
         	       fi
         	       if [ $loop -eq 4 ]
         	       then
         	   	echo "You have reached the maximum retry limt. exiting......"
         	   	exit 1
         	       fi
         	done
          
          if [ managedssl -eq 1 ]
          then
	        loop=1
                while [ $loop -lt 4 ]
                do
	               echo "Enter the SSL Port For Server $srvrCountLoop :"
   	               read mngdSrvrSSLPort
           	       if [ -z "$mngdSrvrSSLPort" ]
         	       then
         	         echo "SSL Port for  all Managed Servers has been disabled."
         	         managedssl=0
         	         break
         	        else
         	          if [ $mngdSrvrSSLPort -gt 1024 -a $mngdSrvrSSLPort -le 65536 ]                     
                    then                                                                           
                        break                                                                       
                    else                                                                           
                        echo "Invalid  SSL Listen Port For Server $srvrCountLoop entered kindly re enter"
                        loop=`expr $loop + 1`                                                       
                    fi                                                                             

         	       fi
         	       if [ $loop -eq 4 ]
         	       then
         	   	echo "You have reached the maximum retry limt. exiting......"
         	   	exit 1
         	       fi
         	done
         	fi
	        srvrCountLoop=`expr $srvrCountLoop + 1`
		if [ $srvrCountLoop -le $managedServerListCount ]
		then
			managedServerList=$managedServerList","
			mngdSrvrHost=$mngdSrvrHost","
			mngdSrvrPort=$mngdSrvrPort","
			if [ managedssl -eq 1 ]
			then
			 mngdSrvrSSLPort=$mngdSrvrSSLPort","
			fi
		fi
	        managedServerListString=$managedServerListString$managedServerList
	        mngdSrvrHostString=$mngdSrvrHostString$mngdSrvrHost
	        mngdSrvrPortString=$mngdSrvrPortString$mngdSrvrPort
	        if [ managedssl -eq 1 ]
	        then
	         mngdSrvrSSLPortString=$mngdSrvrSSLPortString$mngdSrvrSSLPort
               else
               mngdSrvrSSLPortString=""
          fi 
            done

	  loop=1
	  while [ $loop -lt 4 ]
	  do
	    echo "Enter the MultiCast Address of the Cluster where Bancs Online application deployment needs to be targeted:"
	    read clusterMulticastAddress
	    if [ -z "$clusterMulticastAddress" ]
	    then
	      echo "Multi Cast Address the Cluster where Bancs Online application deployment needs to be targeted not set. Please try again."
	      loop=`expr $loop + 1`
	     else
	       ip=$clusterMulticastAddress
	       checkip 2>/dev/null
	       if [ $class = "D" ]
	       then
	        break
	       elif [ $class = "I" ]
	       then
	         echo "Invalid IP address entered kindly re enter"
	         loop=`expr $loop + 1`
	       else
	         echo "IP entered in not a D class address kindly re enter"
	         loop=`expr $loop + 1`
	       fi
	    fi
	    if [ $loop -eq 4 ]
	    then
		echo "You have reached the maximum retry limt. exiting......"
		exit 1
	    fi
	  done
          break;;

	[sS]* )
	  loop=1
	  while [ $loop -lt 4 ]
	  do
	    #echo "Enter the name of the Managed server where the Bancs Online Application needs to be deployed." 
	    #echo "If appDepMode is [S], Managed server is Defaulted to \"server1\""
	    if [ $appDepMode="S" ]
	    then
		standAloneManagedServer="server1"
		echo "Name of the Managed server is set to: \"server1\" as appDepMode=\"S\""
		break
	    else
  	      read standAloneManagedServer
	      if [ -z "$standAloneManagedServer" ]
	      then
	        echo "Name of the Managed server where the application needs to be deployed is not set. Please try again."
	        loop=`expr $loop + 1`
	       else
	          break
	      fi
	      if [ $loop -eq 4 ]
	      then
		  echo "You have reached the maximum retry limt. exiting......"
		  exit 1
	      fi
            fi
	  done
	    #echo "Enter the Listen Address of the Managed Server where Bancs Online application needs to be deployed: [DEFAULT is Local System IP: $ipaddress]"
	    #read standAloneManagedServerListenAddress
	    if [ -z "$standAloneManagedServerListenAddress" ]
	    then
	      standAloneManagedServerListenAddress=$ipaddress
	    fi

	esac
	## Case Statement ends
}

setDBProperty() {
        loop=1
        while [ $loop -lt 4 ]
        do
          #echo "Enter Database type. Type O for Oracle, type D for DB2.[Mandatory] [DEFAULT: D]"
          #read dbType
          if [ -z "$dbType" ]
          then
            echo "Database type is set to DEFAULT option."
            dbType="D"
            break
           else
                case $dbType in
                    [dD])
                      dbType="D"
                      break ;;
                    [oO])
                      dbType="O"
                      break ;;
                    *)
                      echo "Invalid Option Entered. Please try again."
                      loop=`expr $loop + 1` ;;
                 esac
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
        #echo "Enter DataBase Type [R: RAC CLUSTER][S: NON CLUSTERED]:[DEFAULT is: S]"
        #read DBMSMode
         if [ -z "$DBMSMode" ]
          then
            echo "DataBase Type is set to DEFAULT option."
            DBMSMode="S"
            db_nodes=1;
            break;
          elif [[ $DBMSMode = "R" || $DBMSMode = "r" ]]
          then
            dbnodesloop=1
            while [ $dbnodesloop -lt 4 ]
            do
            echo "Enter No Of Nodes In The RAC Cluster:"
            read db_nodes;
            if [ db_nodes -gt 0 ]
            then
             break;
            else
              echo "Invalid no of nodes set kindly re enter "
              dbnodesloop=`expr $dbnodesloop + 1`
            fi
            if [ $dbnodesloop -eq 4 ]
            then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
            fi
            done
            if [ db_nodes -gt 0 ]
            then
              break;
            fi
          elif [[ $DBMSMode = "S" || $DBMSMode = "s" ]]
          then
            db_nodes=1;
            break;
          else
            echo "Invalid Option Entered. Please try again."
            loop=`expr $loop + 1`
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
          done

        loop=1
        db_loop=1;
        while [ $loop -lt 4 ]
        do
          while [ $db_loop -le $db_nodes ]
          do
          echo "Enter DB Host For Server $db_loop:"
          read dbhost
          portloop=1
          while [ $portloop -lt 4 ]
          do
          echo "Enter DB Port For Server $db_loop:"
          read port
           if [ $port -gt 1024 -a $port -le 65536 ]
           then
             break
           else
             echo "Invalid DB port entered kindly re enter"
             portloop=`expr $portloop + 1`
           fi
          if [ $portloop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
          done
          cat_str0="$dbhost:$port"
          if [ -z "$cat_str1" ]
          then
          cat_str1=$cat_str0
          else
          cat_str1=$cat_str1,$cat_str0
          fi
          db_loop=`expr $db_loop + 1`
          done
          echo "Enter the Database Name:"
          read dbName
          cat_str2=$cat_str1
        loop=4
        done
        dbAddressString=$cat_str2

        loop=1
        while [ $loop -lt 4 ]
        do
          echo "Enter database UserId for Online Application. [Mandatory]:"
          read dbOnlineUserId
          if [ -z "$dbOnlineUserId" ]
          then
            echo "User ID for Database is  not set. Please try again."
            loop=`expr $loop + 1`
           else
             break
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
         done

        loop=1
        while [ $loop -lt 4 ]
        do
          echo "Enter database Password for Online Application. [Mandatory]:"
          stty -echo
          read dbOnlinePassword
          stty echo
          echo "\r"
          if [ -z "$dbOnlinePassword" ]
          then
            echo "Password for Database Online user is not set. Please try again."
            loop=`expr $loop + 1`
          else
             break
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          echo "Enter the Database Schema Name:"
          read dbSchemaName
          if [ -z "$dbSchemaName" ]
          then
            echo "Database Schema Name is not set. Please try again."
            loop=`expr $loop + 1`
          else
             break
          fi

          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          echo "Enter the DB2 Database Driver Path:"
          read dbDriverJarPath
          if [ -z "$dbDriverJarPath" ]
          then
            echo "Database Driver Path is not set. Please try again."
            loop=`expr $loop + 1`
          else
             break
          fi

          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done

        loop=1
        while [ $loop -lt 4 ]
        do
          #echo "Select the application logging log_mode[Error[E] Debug[D] :[DEFAULT :E]:"
          #read log_mode
          if [ -z "$log_mode" ]
          then
            log_mode="E"
            break;
          elif [[ $log_mode = "d"  || $log_mode = "D"  ]]
          then
            log_mode="D"
            break;
          elif [[ $log_mode = "e"  || $log_mode = "E"  ]]
          then
            log_mode="E"
            break;
          else
            echo "Invalid Mode Entered. Please try again."
            loop=`expr $loop + 1`
          fi
          if [ $loop -eq 4 ]
          then
              echo "You have reached the maximum retry limt. exiting......"
              exit 1
          fi
        done
}

createPropertyFile()
{
	#generation of $scriptHome/wasAdminScripts/was.config.properties
	if [ -f $scriptHome/wasAdminScripts/was.config.properties ]
	then
	   mv -f $scriptHome/wasAdminScripts/was.config.properties $scriptHome/wasAdminScripts/was.config.properties.bak
	fi
	loop=1
	while [ $loop  -eq 1 ]
	do
	  loop=0

		echo "####################################################"
		echo "#############  was.config.properties ###############"
		echo "####################################################"

		echo "#-----------------------------------------------------"
		echo "#  Application Server related properties"
		echo "#-----------------------------------------------------"
	
		echo "# IBM Websphere Installation root path. Mandatory"
		echo "wasRoot=$wasRoot"

		echo "#-----------------------------------------------------"
		echo "#  Installer related properties"
		echo "#-----------------------------------------------------"

		echo "Installation directory for the application"
                echo "installDir=$installDir"
		
		echo "Installer Proprty file"
                echo "installerPropertyFile=$installerPropertyFile"

		echo "Home directory for the main script files"
                echo "scriptHome=$scriptHome"

		echo "#--------------------------------------------------------"
		echo "# Application Server/s configuration specific properties"
		echo "#--------------------------------------------------------"
	
		echo "# Application deployment Mode: Cluster or stand alone. Valid values are [C] for Cluster [S] for Standalone)"
		echo "appDepMode=$appDepMode"

		echo "# Flag whether the WebSphere Application Installation is Netword Deployment Version,[Y] for yes, [N ]for No. Mandatory"
		echo "wasNDVersion=$wasNDVersion"

		echo "# Flag indicating the type of profile to be created. Mandatory"
		echo "# [D] for deployment manager profile, [C] for custom profile and [B] for both custom and deployment Manager, [A]for AppServer"
		echo "profileType=$profileType"
	
		echo "# Flag indicating whether admin security is enabled or disabled. Valid values [Y] for Yes [N] for No"
		echo "securityEnabled=$securityEnabled"
	
		echo "#-----------------------------------------------------"
		echo "# Deployment Manager profile information"
		echo "#-----------------------------------------------------"

		echo "# Name of profile in which admin server will be reside. Mandatory if wasNDVersion is [Y] and profileType is either [B] or [D]"
		echo "managerProfileName=$managerProfileName"
	
		echo "# IP address or hostname of Deployment Manager machine. Mandatory if wasNDVersion is [Y] and profileType is [B], [C] or [D]"
		echo "managerHost=$managerHost"

		echo "# SOAP connector port of Deployment Manager machine. Mandatory if wasNDVersion is [Y] and profileType is [C]"
		echo "managerPort=$managerPort"
	

		echo "# Use system generated cell and node names. IF [Y], custom cell and node names will be ignored while profile creation."
		echo "defaultNodeAndCell=$defaultNodeAndCell"

		echo "# Name of cell where admin server profile and custom profile configurations are kept. Mandatory"
		echo "cellName=$cellName"

		echo "# User name that will control access to admin server (default:wasadmin). Recommended if securityEnabled is [Y]"
		echo "adminUserName=$adminUserName"

		echo "# Password of user that will control access to admin server (default:wasadmin). Recommended if securityEnabled is [Y]"
		echo "adminPassword=$adminPassword"

		echo "#-----------------------------------------------------"
		echo "# Custom/Application Server  profile information"
		echo "#-----------------------------------------------------"

		echo "# Name of profile in which application server/s will be created/reside. Mandatory"
		echo "customProfileName=$customProfileName"

		echo "# Name of the Node where Custom profiles' Servers resides. Optional (default:),  [B] or [C]"
		echo "customNodeName=$customNodeName"
	
		echo "# Java runtime arguments for server. Optional"
		echo "jvmArgs=$jvmArgs"

		echo "#-----------------------------------------------------"
		echo "# Application Deployment in Cluster Configuration"
		echo "#-----------------------------------------------------"

		echo "# Name of the Cluster where EAI Online application deployment needs to be targeted. Mandatory if appMode is [C]"
		echo "ClusterName=$ClusterName"

		echo "# Comma separated list of names of cluster member servers. Mandatory if appMode is [C]"
		echo "ManagedServersList=$ManagedServersList"

		echo "# Host IPs of Managed Servers those are members of the Cluster. Mandatory if appMode is [C]"
		echo "# Each IP should correspond to the servername mentioned in ManagedServersList"
		echo "ManagedServersListenAddressList=$ManagedServersListenAddressList"

		echo "# Each Node Name should correspond to the servername mentioned in ManagedServersList, Mandatory if appMode is [C]"
		echo "CustomNodeNameList=$CustomNodeNameList"

		echo "#-----------------------------------------------------"
		echo "# Application Deployment for Stand alone Managed Server Configuration"
		echo "#-----------------------------------------------------"

		echo "# Name of the Server where EAI Online application deployment needs to be targeted. Mandatory if appMode is [S]"
		echo "#Dont change this value(server1)"
		echo "standAloneManagedServer=$standAloneManagedServer"

		echo "# In standalone mode the Listen Host of the Managed server where the application needs to be deployed. Mandatory if appMode is [S]"
		echo "standAloneManagedServerListenAddress=$standAloneManagedServerListenAddress"

		echo "#-----------------------------------------------------"
		echo "# Virtual Host settings for web server"
		echo "#-----------------------------------------------------"

		echo "# Comma separated list of Web Server Host Name/s or IP address/es . Optional need not be specified"
		echo "webServerHostList=$webServerHostList"

		echo "# Comma Separated Web Server Port list. Optional need not be specified."
		echo "# But if you have specified webServerHostList then you need to specify its value."
		echo "# Each port should correspond to the comma separated webServerHostList"
		echo "webServerPortList=$webServerPortList"

		echo "#-----------------------------------------------------"
		echo "# Database related properties"
		echo "#-----------------------------------------------------"

		echo "# DB Mode (Standalone - S or Cluster - R). Optional need not be specified.  Defaults to [S]"
		echo "DBMSMode=$DBMSMode"

		echo "# Database type. Type "O" for Oracle, type "D" for DB2..Mandatory"
		echo "dbType=$dbType"

		echo "# Directory location where database driver jars are kept. Mandatory"
		echo "dbDriverJarPath=$dbDriverJarPath"

		echo "# Hostname/IP of machine where database is hosted. <IP:Port>. Mandatory"
		echo "dbAddressString=$dbAddressString"

		echo "# Name of database. For Oracle enter SID value and for DB2 enter instance name. Mandatory"
		echo "dbName=$dbName"

		echo "# Schema name. For oracle enter the DBA user-id, for DB2 enter current schema name. Mandatory"
		echo "dbSchemaName=$dbSchemaName"

		echo "# Enter database UserId for Online Application. Mandatory"
		echo "dbOnlineUserId=$dbOnlineUserId"
	
		echo "# Enter database Password for Online Application. Mandatory"
		echo "dbOnlinePassword=$dbOnlinePassword"

		echo "#### Server JVM Heap Size related properties ##########3"
	
		echo "# Initial heap size(Positive Integer value in MB). Optional-  256 by default"
		echo "initialHeapSize=$initialHeapSize"
		echo "# Maximum heap size (Positive Integer value in MB). Optional - 512 by default"
		echo "maxHeapSize=$maxHeapSize"

		echo "#-----------------------------------------------------"
		echo "# Application specific configuration"
		echo "#-----------------------------------------------------"

		echo "# Installation directory/path"
		echo "# Please create this directory before installation and grant write permissions to the User Id used for installation. Mandatory"
		echo "appHome=$appHome"

		echo "#Application Deployment Directory"
		echo "deploymentDir=$deploymentDir"

		echo "#Logs directory/path"
		echo "#Please create this directory before installation and grant write permissions to the User Id used for installation. Mandatory"
		echo "logDir=$logDir"

		echo "# Display Name of  Online Application  that will be deployed as an EAR on Application Server. Mandatory"
		echo "appName=$appName"

		echo "# Display Name of  Online Application  that will be deployed as an EAR on Application Server. Mandatory"
		echo "archiveFileName=$archiveFileName"

		echo "# Application Mode (Production/Development)  Mandatory. Possible values are: [D] for DEBUG(Development Mode), and [E] for ERROR(Production Mode), Optional. Defaults to [E]"
		echo "log_mode=$log_mode"

		echo "#GMT to Local and Site Minder Settings"
		echo "gmt_local=Y"

		echo "#Support for Site Minder needed, Y for yes, N for no, mandatory"
		echo "site_minder=N"


		echo "#Line number separator in viewing parsed details, mandatory"
		echo "#C for comma, H for hypen"
		echo "linenosep=C"

		echo "#Appserver type(WS - Websphere)"
		echo "appservertype=WS"

		echo "# HTTP or HTTPS protocol for Interface. Valid Values are [http] for HTTP [https] for HTTPS. Optional"
		echo "sslenbl="

		echo "#-----------------------------------------------------"
		echo "#"
	done > $scriptHome/wasAdminScripts/was.config.properties
}

chkWasAdminOption() {
	case $arg1 in
        	[Ii]nfo)
	                sh $scriptHome/wasAdminScripts/infoAboutWAS.sh
        	        exit -1
                	;;
	        [Dd]elete)
        	        sh $scriptHome/wasAdminScripts/deleteProfiles.sh
                	retval=$?
	                if [ $retval -eq 0 ]
        	        then
                	        echo "Profile Deletion Complete!...."
	                else
        	                echo "Profile Deletion FAILED !..."
                	fi
	                exit -1
        	        ;;
	        [Uu]n[Ii]nstall)
        	        sh $scriptHome/wasAdminScripts/uninstallApp.sh
                	retval=$?
	                if [ $retval -eq 0 ]
        	        then
                	        echo "$arg1 Complete!...."
	                else
        	                echo "Uninstallation FAILED !..."
                	fi
	                exit -1
        	        ;;
	        [Ss]etup)
        	        sh $scriptHome/wasAdminScripts/createProfiles.sh
                	retval=$?
	                if [ $retval -eq 0 ]
        	        then
                	        echo "$arg1 Configuration Complete!...."
	                else
        	                echo "$arg1 configuration FAILED !..."
                	fi
	                ;;
	        [Aa]dmin)
        	        appDepMode=`cat $scriptHome/wasAdminScripts/was.config.properties| grep "appDepMode[ ]*=" | grep -v "#" | cut -f2 -d'='`
	                if [ -z "$appDepMode" ]
        	        then
                	        echo "appDepMode must be specified in $scriptHome/wasAdminScripts/was.config.properties. Exiting with error."
	                        exit -1
        	        fi
                	if [ $appDepMode = "s" -o $appDepMode = "S" ]
	                then
        	                sh $scriptHome/wasAdminScripts/createStandAloneServerConfig.sh
                	else
	                  if [ $appDepMode = "c" -o $appDepMode = "C" ]
        	          then
                	        sh $scriptHome/wasAdminScripts/createClusterConfig.sh
	                  else
        	             echo "appDepMode can be either S or C in $scriptHome/wasAdminScripts/was.config.properties. Exiting with error."
                	     exit -1
	                  fi
        	        fi
                	retval=$?
	                if [ $retval -eq 0 ]
        	        then
                	        echo "$arg1 Configuration Complete!...."
	                else
        	                echo "$arg1 Configuration FAILED !..."
                	fi
	                ;;
        	[Pp]repare)
	                sh $scriptHome/wasAdminScripts/prepare.sh
        	        retval=$?
                	if [ $retval -eq 0 ]
	                then
        	                echo "$arg1 Preparation Complete!...."
                	        #return $retval
	                else
        	                echo "$arg1 Preparation FAILED !..."
                	fi
	                ;;
	        [Ii]nstall)
        	        #sh $scriptHome/wasAdminScripts/installApp.sh
        	        sh $scriptHome/wasAdminScripts/installApp.sh
                	retval=$?
	                if [ $retval -eq 0 ]
        	        then
                	        echo "$1 Configuration Complete!...."
	                else
        	                echo "$1 configuration FAILED !..."
                	fi
	                ;;
	        [Uu]n[Ii]nstall)
        	        sh $scriptHome/wasAdminScripts/uninstallApp.sh
                	retval=$?
	                if [ $retval -eq 0 ]
        	        then
                	        echo "$arg1 Complete!...."
	                else
        	                echo "$arg1 FAILED !..."
                	fi
	                ;;
	         [Aa]uto)
        	        sh $scriptHome/wasAdminScripts/wasAdminConfig.sh -s Setup
                	sh $scriptHome/wasAdminScripts/wasAdminConfig.sh -s Admin
	                sh $scriptHome/wasAdminScripts/installApp.sh
        	        ;;
	        *)
        	        echo "Invalid option specified."
			echo "I'm in main area!"
			echo $1
			echo $arg2
	                exit -1
        	        ;;
	esac
}

case $arg1 in
         [aA]uto | [sS]etup | [aA]dmin | [iI]nstall | [pP]repare | [dD]elete | [uU]n[iI]nstall)
                if [ $silent = "N" ]
                then
                       #bannermsg=$1
                       #InstallBanner
                       echo "Just trying it out..."
                 fi
                 echo "$arg1 option Enabled"
                 startScript
                 ;;
        *)
                #ppHomeUsage
                echo "Invalid Option...You need to see what option you have enter!!"
                echo "Don't repeat it again!"
                echo "Arg1: $arg1 option Enabled"
                exit -1
                ;;
esac
