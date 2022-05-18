#!/bin/bash

remote=`who am i | awk '{ print $5 }' | sed 's/(//g' | sed 's/)//g'`
dizhi=`curl -q -s http://freeapi.ipip.net/$remote | awk -F '"' '{print $2"-"$4"-"$6}'`
mess=`echo -e "腾讯云香港成功登录\nIP地址为:$remote\n登录的位置:$dizhi"`
if [ ! $remote ]; then
	echo "NULL"
else
	curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=4c30def1-8f2c-458b-b8a5-97601c193dbe' -H 'Content-Type: application/json' -d '
   {                      
        "msgtype": "text",
        "text": {                   
            "content": "'"${mess}"'"
        }
   }' > /dev/null 2>&1
fi
