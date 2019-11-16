a=1
while(1)
{
lsof |awk '{print ""$2" "$9""}' |grep 30276 >result`echo $a`.txt

sleep 5;
a=`echo $a + 1 | bc`
}
