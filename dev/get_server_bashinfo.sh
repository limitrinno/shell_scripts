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

# 判断是否有全局文件
if [ -f /mnt/shell/global_variable.sh ]; then
        echo "{全局变量}文件检测成功,继续执行......"
else
        echo "/mnt/shell/global_variable.sh 文件不存在,请下载全局变量并修改{wget -P /mnt/shell http://github.2331314.xyz:5550/https://raw.githubusercontent.com/limitrinno/shell_scripts/master/stable/global_variable.sh}，退出中......"
        exit
fi

# 调用Ceph的变量
source /mnt/shell/global_variable.sh

# 运行时间
#current=`date "+%Y-%m-%d %H:%M:%S"`
#timeStamp=`date -d "$current" +%s`
#将current转换为时间戳，精确到毫秒  
#currentTimeStamp=$((timeStamp*1000+`date "+%N"`/1000000)) 
#echo $timeStamp
#echo $currentTimeStamp
#server_system_up=`top -b -n 1 | grep 'load' | awk '{print $3}'`

# CPU 指标
## 系统当前的总负载
server_cpu_total_load=`top -b -n 1 |grep Cpu | cut -d "," -f 1 | cut -d ":" -f 2 | sed 's/ //g' | sed 's/us//g'`
## 系统1分钟负载
server_cpu_1min_load=`uptime | grep -o "load average.*" | cut -d':' -f 2 | cut -d',' -f 1 | sed 's/ //g'`
## 系统5分钟负载
server_cpu_5min_load=`uptime | grep -o "load average.*" | cut -d':' -f 2 | cut -d',' -f 2 | sed 's/ //g'`
## 系统15分钟负载
server_cpu_15min_load=`uptime | grep -o "load average.*" | cut -d':' -f 2 | cut -d',' -f 3 | sed 's/ //g'`

# 内存指标
server_mem_total=`free | grep "Mem:" | awk '{print $2}'`
server_mem_use=`free | grep "Mem:" | awk '{print $3}'`
server_swap_total=`free | grep "Swap:" | awk '{print $2}'`
server_swap_use=`free | grep "Swap:" | awk '{print $3}'`

# 网络指标

# 容量指标
echo "" > /tmp/push.txt && sed -i '1d' /tmp/push.txt
i=0
while ((++i));
do
server_df_device=`df | grep -v "tmpfs" | sed '1d' | sed -n "$i"p | awk '{print $1,$2,$4,$6}' | cut -d' ' -f4`
server_df_mountpoint=`df | grep -v "tmpfs" | sed '1d' | sed -n "$i"p | awk '{print $1,$2,$4,$6}' | cut -d' ' -f1`
server_df_use=`df | grep -v "tmpfs" | sed '1d' | sed -n "$i"p | awk '{print $1,$2,$4,$5,$6}' | cut -d' ' -f4 | sed 's/%//g'`
check_null=`df | grep -v "tmpfs" | sed '1d' | sed -n "$i"p | awk '{print $1,$2,$4,$5,$6}' | cut -d' ' -f4`
if [[ $check_null == "" ]];then
	break
fi
echo "server_df_info{server_df_device='"$server_df_device"',server_df_mountpoint='"$server_df_mountpoint"'} $server_df_use" >> /tmp/push.txt
done

# 上传服务器
sed -i s#\'#\"#g /tmp/push.txt
curl -XPOST --data-binary @/tmp/push.txt http://$szsrv:49091/metrics/job/$job_name/instance/$instance_name
rm -rf /tmp/push.txt

# 上传服务器
cat <<EOF | curl --data-binary @- http://$szsrv:49091/metrics/job/$job_name/instance/$instance_name
server_cpu_total_load $server_cpu_total_load
server_cpu_1min_load $server_cpu_1min_load
server_cpu_5min_load $server_cpu_5min_load
server_cpu_15min_load $server_cpu_15min_load
server_mem_total $server_mem_total
server_mem_use $server_mem_use
server_swap_total $server_swap_total
server_swap_use $server_swap_use
EOF

# END
echo "Upload Success!"
