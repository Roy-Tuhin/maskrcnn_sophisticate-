#!/bin/bash
# server load monitoring script by Lloyd Standish, lloyd at crnatural.net
# This script is freeware released under GNU GPL.

loadpath="/home/was6/BhaskarM/WASAdmin/localScripts/lmlog"
maxload=.70 # example .75 = 75% load average
minwarninterval=3600 # minimum interval between warning emails, seconds

# uncomment only one of the folowing 3 lines
loadavginterval=1 #for one minute load averages
#loadavginterval=2 #for 5 minute load averages
#loadavginterval=3 #for 10 minute load averages

#cat /proc/loadavg #debugging

if [ ! -d "$loadpath" ]; then
	mkdir "$loadpath"
fi
#if [ ! -f "$loadpath/loadcount" ]; then
#	echo "0" "$loadpath/loadcount"
#fi

#count=`cat $loadpath/loadcount`
now=`date +%s`
prev="0"
if [ -f "$loadpath/loadsecs" ]; then
	prev=`cat $loadpath/loadsecs`
fi
# check if average load is too high
loadavg=`cat /proc/loadavg | cut -d ' ' -f $loadavginterval`
if [ `echo $loadavg \> $maxload | bc` -eq 1 ]; then
	echo "$loadavg `date +%T`" >> "$loadpath/loadrpt"
fi

#if [ `echo $now \> $prev \+ $minwarninterval | bc` -eq 1 -a -f "$loadpath/loadrpt" ]; then
test=`echo $now` # \> $prev \+ $minwarninterval`
#echo $test
if [ `echo $now '>' $prev '+' $minwarninterval | bc` -eq 1 -a -f "$loadpath/loadrpt" ]; then
	case $loadavginterval in
		1) loadminutes="one";;
		2) loadminutes="five";;
		3) loadminutes="ten";;
	esac
	echo "Server `hostname`: Warning, $loadminutes minute load average above $maxload! Incidents in last $minwarninterval seconds:" | cat - "$loadpath/loadrpt"
	rm -f "$loadpath/loadrpt"
	echo $now > "$loadpath/loadsecs"
fi
