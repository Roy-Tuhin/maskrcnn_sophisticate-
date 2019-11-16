#!/bin/bash
treegen=$1
csvFileName=$2

if [ -z "$treegen" ]
then
	echo "usage: tree2csv.sh <dirPath> [<csvFileName>]"
	echo "Default csvFileName: tempTree.csv"
	exit -1
fi

if [ -z $csvFileName ]
then
	csvFileName=tempTree.csv
	echo "Default csvFileName: $csvFileName"
fi	
tree --dirsfirst $treegen > $csvFileName
sed -i 's/ //g' $csvFileName
sed -i 's/[\|,`]--/,/g' $csvFileName
sed -i 's/|/,/g' $csvFileName
sed -i 's/$/,/g' $csvFileName
echo "$csvFileName is the generated File"

#Tree Level
line=(`cat $csvFileName`)
for (( i=0; i < ${#line[*]}; i++ ))
do
        count[i]=${line[i]}
done

echo "Number of Lines in CSV File: ${#count[*]}"
word=(`cat tempTree.csv| awk '{gsub(",","^");print}'`)
echo "# of lines ${#word[*]}"

if [ -f aryLen.tmp ]
then
        >|aryLen.tmp
fi

for (( j=0; j < ${#word[*]}; j++ ))
do

        echo ${word[j]} | awk '{split($0,array,"^")} END{print length(array)}' >> aryLen.tmp
        #echo  ${word[j]} | awk '{split($0,array,"^")} END{print length(array);print array[1]}'
done
echo "done"

echo `sort -u -n -r aryLen.tmp`

level=(`sort -u -n -r aryLen.tmp`)

echo ${#level[*]}

for (( k=0; k < ${level[0]}; k++ ))
do
	newline=$newline"Level_$k,"
done
echo $newline

#sed -i '/^$/d' $csvFileName
sed -i '$d' $csvFileName
sed -i '1d' $csvFileName
sed -i '1i\'$newline'' $csvFileName
if [ -f aryLen.tmp ]
then
	rm aryLen.tmp
fi

