#!/bin/bash

# Ubuntu sudo
echo "password" |sudo -S ls > /dev/null

# 检测系统盘
systemdisk=`df -h | grep /dev/ | sed '2,999d' | awk '{print $1}' | cut -d'/' -f 3 | sed 's/[0-9]//g'`
echo "当前系统的系统盘为:$systemdisk,如不正确，请修改当前目录下的disklist.txt"

#lsblk | awk '{print $1}' | grep -v ceph | grep -v $1 > disklist.txt
#lsblk | awk '{print $1}' | grep -vE "$systemdisk|NAME|ceph|nvme" > /usr/local/node_exporter/disklist.txt
sudo touch /usr/local/node_exporter/disklist.txt && sudo chmod 777 /usr/local/node_exporter/disklist.txt
sudo fdisk -l | grep "Disk /dev" | sed s/://g | sed s#/dev/##g | grep -vE "$systemdisk\>|ceph|nvme|loop" | awk '{print $2}'  > /usr/local/node_exporter/disklist.txt

if [ $? -eq 0 ];then
        disknums=`cat /usr/local/node_exporter/disklist.txt | wc -l`
        echo "成功获取硬盘盘符 $disknums 个,请检查文件内容并且执行下一个脚本"
fi
