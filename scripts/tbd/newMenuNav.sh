#!/bin/bash
ld=`tput bold`
bld=`tput smso`
nrml=`tput rmso`
reset=`tput reset`
red=$(tput setaf 1)
normal=$(tput sgr0)
rev=$(tput rev)
cyan_start="\033[36m"
cyan_stop="\033[0m"

processmgmnt=(pstree top iostat ps uname uptime w /sbin/lsmod /sbin/runlevel hostname)
memcmds=(vmstat free pmap top sar time as cat One)
systeminfo=(uname)
cmdarry=(Select Next Previous)
PS3="Choose (1-${#cmdarry[*]}):"


echo "Choose from the list below."
#echo "1.Select		2.Next		3.Previous"

select cmdtypname in ${cmdarry[@]}
do
        case  $cmdtypname in
                   Select)
                                PS3="Choose (1-${#processmgmnt[*]}):"
                                select optn in ${processmgmnt[@]}
                                do
                                        echo "Executing as shell command..."
                                        $optn
                                        break
                                done
                                ;;
                     Next)
                                PS3="Choose (1-${#memcmds[*]}):"
                                select optn in ${memcmds[@]}
                                do
                                        echo "Executing as shell command..."
                                        $optn
                                        break
                                done
                                ;;
                Previous)
                                PS3="Choose (1-${#systeminfo[*]}):"
                                select optn in ${systeminfo[@]}
                                do
                                        echo "Executing as shell command..."
                                        $optn
                                        break
                                done
                                ;;
                           *)
                                ;;
        esac
        if [ "$cmdtypname" = "" -o "$optn" = "" ]; then
                echo "Error in entry."
                exit 1
        fi
        break
done
