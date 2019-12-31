# model=$(stat -c '%n' /home/nikhil/Documents/* | sort -k1,1nr | head -1)
model=$(stat -c '%n' /aimldl-dat/logs/lanenet/model/061219_175743/* | sort -k1,1nr | head -1)
echo ${model}
