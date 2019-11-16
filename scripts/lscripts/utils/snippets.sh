
# get filename
echo -n "enter file name : "
read filename
 
# make sure file exits for reading
if [ ! -f $filename ]; then
  echo "filename $filename does not exists."
  exit 1
fi
 
# convert uppercase to lowercase using tr command
tr '[a-z]' '[a-z]' < $filename

# https://stackoverflow.com/questions/1102859/how-to-convert-all-text-to-lowercase-in-vim
#:%s/.*/\L&/g


