#hname=`hostname`
echo "Welcome on $hname."
echo -e "Kernel Details: " `uname -smr`
echo -e "`bash --version`"
echo -ne "Uptime: "; uptime
echo -ne "Server time : "; date
lastlog | grep "root" | awk {'print "Last login from : "$3; print "Last Login Date & Time: ",$4,$5,$6,$7,$8,$9;}'
