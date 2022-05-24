#!/bin/bash

# Pushgateway Server
hzsrv="121.196.127.74"
szsrv="120.79.15.130"

# 检查/mnt/下是否存在shell目录
if [[ -d /mnt/shell ]];then
        echo "yes"
else
        mkdir -p /mnt/shell
fi

# 检查是否安装了smartmontools
ls /sbin/smartctl > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
yum -y install smartmontools
fi

# 判断是否有全局文件
if [ -f /mnt/shell/global_variable.sh ]; then
        echo "{全局变量}文件检测成功,继续执行......"
else
        echo "/mnt/shell/global_variable.sh 文件不存在,请下载全局变量并修改{wget -P /mnt/shell http://github.2331314.xyz:5550/https://raw.githubusercontent.com/limitrinno/shell_scripts/master/stable/global_variable.sh}，退出中......"
        exit
fi

# 判断是否有硬盘列表
if [ -f /mnt/shell/disklist.txt ]; then
	echo "{硬盘列表}文件检测成功,继续执行......"
else
	echo "/mnt/shell/disklist.txt 文件不存在{请执行bash <(curl -sL http://github.2331314.xyz:5550/https://raw.githubusercontent.com/limitrinno/shell_scripts/master/stable/get_storage_disklist.sh)}，退出中......"
        exit
fi

# 调用Ceph的变量
source /mnt/shell/global_variable.sh

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

# smartmontools 信息
# 开始检查信息 请确保当前目录下有disklist.txt文件
# 清空checkdisk.log的内容
echo "" > /mnt/shell/checkdisk.log && sed -i '1d' /mnt/shell/checkdisk.log

while read line
do
# 执行smart检查并写入临时文件
smartctl -a /dev/$line > /mnt/shell/smartdisk.tmp
# 开始检查硬盘基本信息
disk_health=`smartctl -H /dev/$line | grep PASSED | awk '{print $6}'`
Reallocated_Sector_Ct=`cat /mnt/shell/smartdisk.tmp | grep "Reallocated_Sector_Ct" | awk '{print $10}'`
Spin_Retry_Count=`cat /mnt/shell/smartdisk.tmp | grep "Spin_Retry_Count" | awk '{print $10}'`
Temperature_Celsius=`cat /mnt/shell/smartdisk.tmp | grep "Temperature_Celsius" | awk '{print $10}'`
Start_Stop_Count=`cat /mnt/shell/smartdisk.tmp | grep "Start_Stop_Count" | awk '{print $10}'`
Power_Cycle_Count=`cat /mnt/shell/smartdisk.tmp | grep "Power_Cycle_Count" | awk '{print $10}'`
Power_On_Hours_v=`cat /mnt/shell/smartdisk.tmp | grep "Power_On_Hours" | awk '{print $10}'`
Total_LBAs_Written_v=`cat /mnt/shell/smartdisk.tmp | grep "Total_LBAs_Written" | awk '{print $10}'`
Total_LBAs_Read_v=`cat /mnt/shell/smartdisk.tmp | grep "Total_LBAs_Read" | awk '{print $10}'`

# 判断值是否存在
if [[ $Total_LBAs_Written_v == "" ]]; then
	Total_LBAs_Written_v=0
fi
if [[ $Total_LBAs_Read_v == "" ]]; then
	Total_LBAs_Read_v=0
fi
if [[ $Power_On_Hours_v == "" ]]; then
	Power_On_Hours_v=0
fi
# 计算易理解的值
Power_On_Hours_expr=$(($Power_On_Hours_v / 24))
Total_LBAs_Written_expr=$(((((($Total_LBAs_Written_v * 512) / 1024 ) / 1024 ) / 1024)))
Total_LBAs_Read_expr=$(((((($Total_LBAs_Read_v * 512) / 1024 ) / 1024 ) / 1024)))

# 判断值是否存在
if [ $Total_LBAs_Written_expr -eq 0 ]; then
	Total_LBAs_Written_expr="Null"
fi
if [ $Total_LBAs_Read_expr -eq 0 ]; then
	Total_LBAs_Read_expr="Null"
fi

echo "machine_smartctl_info{smartctl_disk='"$line"',disk_health='"$disk_health"',Reallocated_Sector_Ct='"$Reallocated_Sector_Ct"',Spin_Retry_Count='"$Spin_Retry_Count"',Temperature_Celsius='"$Temperature_Celsius"',Start_Stop_Count='"$Start_Stop_Count"',Power_Cycle_Count='"$Power_Cycle_Count"',Power_On_Hours_expr='"$Power_On_Hours_expr"',Total_LBAs_Written_expr='"$Total_LBAs_Written_expr"',Total_LBAs_Read_expr='"$Total_LBAs_Read_expr"'} 0" >> /mnt/shell/checkdisk.log

echo "/dev/$line 运行完成！！！"
done < /mnt/shell/disklist.txt

# 清理smartctl的日志文件
rm -rf /mnt/shell/smartdisk.tmp

# 将文件的单引号替换双引号，pushgateway只能读双引号
sed -i s#\'#\"#g /mnt/shell/checkdisk.log

# 信息上传Pushgateway Server,注意服务器变量
cat <<EOF | curl --data-binary @- http://$szsrv:49091/metrics/job/$job_name/instance/$instance_name
machine_cpu_info{cpumode="$CPUmode",cpus="$CPUs",cpucores="$CPUCores",cpuproc="$CPUProc",cpumhz="$CPUMHz"} 0
machine_mem_info{Memzongrongliang="$Memoryzongrongliang",Memshuliang="$Memoryshuliang",Memdanrongliang="$Memorydanrongliang",Mempinlv="$Memorypinlv",Mempinpai="$Memorypinpai"} 0
machine_produce_info{systeminfo1="$serverinfo1",systeminfo2="$serverinfo2",systemos="$systemos"} 0
machine_systemdisknum_info{systemdisknum="$systemdisknum",datadisknum="$datadisknum",nvmedisknum="$nvmedisknum"} 0
EOF

# 上传smartctl处理出来的硬盘信息，注意服务器变量
curl -XPOST --data-binary @/mnt/shell/checkdisk.log http://$szsrv:49091/metrics/job/$job_name/instance/$instance_name


# 清理smartctl处理出来的硬盘信息
rm -rf /mnt/shell/checkdisk.log

# End
echo "脚本执行成功，数据已上传"
