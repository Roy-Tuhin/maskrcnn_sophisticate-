x=`/sbin/ifconfig`
#echo $x
y=${x#*inet addr:}
y=${x#*lo *inet addr:}
y=${y%% *}

echo "y: $y"
#echo "z: $z"
#echo "t: $t"

