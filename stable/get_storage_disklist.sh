#!/bin/bash

# 检测系统盘
systemdisk=`df -h | grep -v tmpfs | grep -v mapper | grep /dev/ | sed '2,999d' | awk '{print $1}' | cut -d'/' -f 3 | sed 's/[0-9]//g'`
echo "当前系统的系统盘为:$systemdisk,如不正确，请修改当前目录下的disklist.txt"

lsblk | awk '{print $1}' | grep -vE "$systemdisk\>|NAME|ceph|nvme|─|sr0" > /mnt/shell/disklist.txt

if [ $? -eq 0 ];then
        disknums=`cat /usr/local/node_exporter/disklist.txt | wc -l`
        echo "成功获取硬盘盘符 $disknums 个,请检查文件内容并且执行下一个脚本"
fi
