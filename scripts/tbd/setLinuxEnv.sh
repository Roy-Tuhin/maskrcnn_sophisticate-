#!/bin/bash

 export PS2="continue->"

cat <<EOF

References:
http://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/

1. PS1 . Default interaction prompt
sh tableColor.sh
2. PS2 . Continuation interactive prompt
	export PS2="continue->"
3. PS3 . Prompt used by .select. inside shell script
PS3="Select a day (1-4): "
select i in mon tue wed exit
do
  case $i in
    mon) echo "Monday";;
    tue) echo "Tuesday";;
    wed) echo "Wednesday";;
    exit) exit;;
  esac
done


EOF


PS3="Select a day (1-4): "
select i in mon tue wed exit
do
  case $i in
    mon) echo "Monday"
	 sh tableColor.sh
	;;
    tue) echo "Tuesday";;
    wed) echo "Wednesday";;
    exit) exit;;
  esac
done

