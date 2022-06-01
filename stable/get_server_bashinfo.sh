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
sysbootuptime=`who -b | grep -o '[0-9].*'`
server_up_time=`date -d "$sysbootuptime" +%s`

# CPU 指标
## 系统当前的总负载
server_cpu_total_load=`top -b -n 1 |grep Cpu | cut -d "," -f 1 | cut -d ":" -f 2 | sed 's/ //g' | sed 's/us//g'`
## 系统1分钟负载
server_cpu_1min_load=`uptime | grep -o "load average.*" | cut -d':' -f 2 | cut -d',' -f 1 | sed 's/ //g'`
## 系统5分钟负载
server_cpu_5min_load=`uptime | grep -o "load average.*" | cut -d':' -f 2 | cut -d',' -f 2 | sed 's/ //g'`
## 系统15分钟负载
server_cpu_15min_load=`uptime | grep -o "load average.*" | cut -d':' -f 2 | cut -d',' -f 3 | sed 's/ //g'`
# CPU核心
server_cpu_number=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`

# 内存指标
server_mem_total=`free | grep "Mem:" | awk '{print $2}'`
server_mem_use=`free | grep "Mem:" | awk '{print $3}'`
server_swap_total=`free | grep "Swap:" | awk '{print $2}'`
server_swap_use=`free | grep "Swap:" | awk '{print $3}'`

# 网络指标
echo "" > /tmp/netpush.txt && sed -i '1d' /tmp/netpush.txt
i=0
while ((++i));
do
network_card=`ip ad|awk '/state UP/ {print $2}' | sed -n "$i"p | sed 's/://g'`
if [[ $network_card == "" ]];then
        break
fi
#echo -e "流量进入--流量传出    "
old_in=$(cat /proc/net/dev |grep $network_card |awk '{print $2}')
old_out=$(cat /proc/net/dev |grep $network_card |awk '{print $10}')
sleep 2
new_in=$(cat /proc/net/dev |grep $network_card |awk '{print $2}')
new_out=$(cat /proc/net/dev |grep $network_card |awk '{print $10}')
in=$(printf "%.1f%s" "$((($new_in-$old_in)/1024))")
out=$(printf "%.1f%s" "$((($new_out-$old_out)/1024))")
echo "server_network_in{network_device='"$network_card"',network_in='"$in"'} $in" >> /tmp/netpush.txt
echo "server_network_out{network_device='"$network_card"',network_out='"$out"'} $out" >> /tmp/netpush.txt
done

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

# 上传网络数据
sed -i s#\'#\"#g /tmp/netpush.txt
curl -XPOST --data-binary @/tmp/netpush.txt http://$hzsrv:49091/metrics/job/$job_name/instance/$instance_name
rm -rf /tmp/netpush.txt

# 上传硬盘数据
sed -i s#\'#\"#g /tmp/push.txt
curl -XPOST --data-binary @/tmp/push.txt http://$hzsrv:49091/metrics/job/$job_name/instance/$instance_name
rm -rf /tmp/push.txt

# 上传服务器
cat <<EOF | curl --data-binary @- http://$hzsrv:49091/metrics/job/$job_name/instance/$instance_name
server_up_time $server_up_time
server_cpu_total_load $server_cpu_total_load
server_cpu_1min_load $server_cpu_1min_load
server_cpu_5min_load $server_cpu_5min_load
server_cpu_15min_load $server_cpu_15min_load
server_mem_total $server_mem_total
server_mem_use $server_mem_use
server_swap_total $server_swap_total
server_swap_use $server_swap_use
server_cpu_number $server_cpu_number
EOF

# END
echo "Upload Success!"
