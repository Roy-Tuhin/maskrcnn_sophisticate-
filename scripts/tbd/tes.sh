#!/bin/bash
tpram="-f"

echo $#
echo $@
if [ $tpram = "-f" ]
then
	echo hi
else
	echo bye
fi
