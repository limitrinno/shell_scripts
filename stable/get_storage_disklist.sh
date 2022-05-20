#!/bin/bash

#check1=`echo $1`
#echo "请在脚本后输入系统盘的盘符,例如 sda, bash getdisklist.sh sda,排除系统盘"
#if [[ $check1 == '' ]];then
#       echo "未传参数脚本停止运行"
#       exit
#fi

# 检测系统盘
systemdisk=`df -h | grep -v tmpfs | grep -v mapper | grep /dev/ | sed '2,999d' | awk '{print $1}' | cut -d'/' -f 3 | sed 's/[0-9]//g'`
echo "当前系统的系统盘为:$systemdisk,如不正确，请修改当前目录下的disklist.txt"

#lsblk | awk '{print $1}' | grep -v ceph | grep -v $1 > disklist.txt
lsblk | awk '{print $1}' | grep -vE "$systemdisk\>|NAME|ceph|nvme|─|sr0" > /usr/local/node_exporter/disklist.txt
#fdisk -l | grep "Disk /dev" | sed s/://g | sed s#/dev/##g | grep -vE "$systemdisk\>|ceph|nvme" | awk '{print $2}'  > /usr/local/node_exporter/disklist.txt

if [ $? -eq 0 ];then
        disknums=`cat /usr/local/node_exporter/disklist.txt | wc -l`
        echo "成功获取硬盘盘符 $disknums 个,请检查文件内容并且执行下一个脚本"
fi
