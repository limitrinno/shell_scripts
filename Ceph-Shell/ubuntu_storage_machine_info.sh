#!/bin/bash

# 检查是否安装了smartmontools
ls /sbin/smartctl > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
yum -y install smartmontools || sudo apt-get -y install smartmontools
fi

# 检查是否安装了hdparm
ls /sbin/hdparm > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
yum -y install hdparm || sudo apt-get -y install hdparm
fi

# 检查是否安装了lsscsi
ls /bin/lsscsi > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
yum -y install lsscsi || sudo apt-get -y install lsscsi
fi

if [ -f /usr/local/node_exporter/ceph_variable.sh ]; then
        echo "文件检测成功,继续执行......"
else
        echo "/usr/local/node_exporter/ceph_variable.sh 文件不存在，退出中......"
        exit
fi

if [ -f /usr/local/node_exporter/get_storage_disklist.sh ]; then
	echo "文件检测成功,继续执行......"
else
	echo "/usr/local/node_exporter/get_storage_disklist.sh 文件不存在，退出中......"
	exit
fi

if [ -f /usr/local/node_exporter/disklist.txt ]; then
	echo "文件检测成功,继续执行......"
else
	echo "/usr/local/node_exporter/disklist.txt 文件不存在，退出中......"
        exit
fi

# 调用Ceph的变量
source /usr/local/node_exporter/ceph_variable.sh

# CPU的名称
CPUmode=`cat /proc/cpuinfo| grep "model name" | cut -d':' -f 2 | uniq | sed 's/ //g'`
# CPU的实际个数
CPUs=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
# CPU的核心数
CPUCores=`cat /proc/cpuinfo| grep "cpu cores"| uniq | cut -d':' -f 2 | sed 's/ //g'`
# CPU的线程数
CPUProc=`cat /proc/cpuinfo| grep "processor"| wc -l`
# CPU的主频
CPUMHz=`cat /proc/cpuinfo |grep MHz | uniq | cut -d':' -f 2 | sed 's/ //g' | cut -d'.' -f 1 | sed '2,999 d'`

# 内存总容量
Memoryzongrongliang=`lsmem |grep "Total\ online\ memory" | cut -d':' -f 2 | sed 's/    //g'`
# 内存条数量
Memoryshuliang=`sudo dmidecode|grep -P -A5 "Memory\s+Device"|grep Size|grep -v Range |grep -v "No Module Installed" |wc -l`
# 单内存条容量
Memorydanrongliang=`sudo dmidecode|grep -P -A5 "Memory\s+Device"|grep Size|grep -v Range |grep -v "No Module Installed" |head -1 | cut -d':' -f 2 | sed 's/ //g'`
# 内存频率
Memorypinlv=`sudo dmidecode|grep -P -A20 "Memory\s+Device"|grep Speed |grep -v "Configured" |sort -n |uniq | grep -v "Unknown" | cut -d':' -f 2 | sed 's/ //g' | sed '2,999 d'`
# 内存品牌
Memorypinpai=`sudo dmidecode|grep -P -A20 "Memory\s+Device"|grep Manufacturer |grep -v "Not Specified" |sort -n |uniq | grep -v "NO DIMM" | cut -d':' -f 2 | sed 's/ //g'`

# 硬盘数量统计
# 系统盘
systemdisknum=`lsscsi -s | grep "GB" | wc -l`
# 数据盘
datadisknum=`lsscsi -s | grep -E "14.0TB|16.0TB" | wc -l`
# NVME盘
nvmedisknum=`lsblk | grep '^nvme' | wc -l`

# 服务器信息
serverinfo1=`sudo dmidecode | grep 'Product Name' | sed '2d' | cut -d':' -f 2 | sed 's/ //'`
serverinfo2=`sudo dmidecode | grep 'Product Name' | sed '1d' | cut -d':' -f 2 | sed 's/ //'`
# 系统OS的版本信息
systemos=`cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f 2 | sed 's/"//g'`

# 信息上传Pushgateway Server
cat <<EOF | curl --data-binary @- http://120.79.15.130:49091/metrics/job/$job_name/instance/$instance_name
machine_cpu_info{cpumode="$CPUmode",cpus="$CPUs",cpucores="$CPUCores",cpuproc="$CPUProc",cpumhz="$CPUMHz"} 0
machine_mem_info{Memzongrongliang="$Memoryzongrongliang",Memshuliang="$Memoryshuliang",Memdanrongliang="$Memorydanrongliang",Mempinlv="$Memorypinlv",Mempinpai="$Memorypinpai"} 0
machine_produce_info{systeminfo1="$serverinfo1",systeminfo2="$serverinfo2",systemos="$systemos"} 0
machine_systemdisknum_info{systemdisknum="$systemdisknum",datadisknum="$datadisknum",nvmedisknum="$nvmedisknum"} 0
EOF
