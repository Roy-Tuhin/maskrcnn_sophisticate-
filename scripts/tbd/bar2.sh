#!/bin/bash
#!/bin/sh
i=50
echo "0--------20--------40-------60--------80-------100%"
while [ $i -ge 0 ]
do
echo "#\c"
sleep 1
i=`expr $i - 1`
done
