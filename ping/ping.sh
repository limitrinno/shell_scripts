#!/bin/bash
IP_LIST="/root/ping/iplists"
LOG_PATH="/root/ping/plogs"
while read line
do
	{
		DATE_TIME=`date +%Y%m%d_%H_%M`
		PINGOUT=`echo pingout_BJ_"$line"_"$DATE_TIME"`
		PING=`ping -c 120 $line`
		echo "$PING" > /root/ping/ping/$PINGOUT
		if [ $(echo $PING | grep loss | rev | cut -d, -f2 | rev | awk '{print $1}' | sed 's/%//g') -gt 0 ]
		then
		echo "$PING" > $LOG_PATH/$PINGOUT
		error_send="$line 网络不通,请注意检查!"
		f1=`cat $LOG_PATH/error_$line.txt`
		if [ "$error_send" == "$f1" ]; then
			echo "重复发送"
		else
		curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=a2f5c758-4d83-47c7-8fa7-3886ed25e6c7' -H 'Content-Type: application/json' -d '
   {                      
        "msgtype": "text",
        "text": {                   
            "content": "'"$error_send"'"
        }
   }'
			echo "发送成功"
		fi
		fi
		echo "$error_send" > $LOG_PATH/error_$line.txt
	}&
	sleep 1
done < $IP_LIST
find $LOG_PATH -name "pingout_*" -ctime +3 -print | xargs rm -f
find /root/ping/ping/ -name "pingout_*" -ctime +3 -print | xargs rm -f
