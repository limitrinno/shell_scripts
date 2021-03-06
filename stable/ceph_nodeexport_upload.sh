#!/bin/bash

# Pushgateway Server
hzsrv="121.196.127.74"
szsrv="120.79.15.130"

# 判断是否有全局文件
if [ -f /mnt/shell/global_variable.sh ]; then
        echo "{全局变量}文件检测成功,继续执行......"
else
        echo "/mnt/shell/global_variable.sh 文件不存在,请下载全局变量并修改{wget -P /mnt/shell http://github.2331314.xyz:5550/https://raw.githubusercontent.com/limitrinno/shell_scripts/master/stable/global_variable.sh}，退出中......"
        exit
fi

# 调用Ceph的变量
source /mnt/shell/global_variable.sh

# 获取主机名
hostname_name=`hostname -f | cut -d'.' -f1`
# 截取Ceph的Mgr监控节点
mgrservices=`ceph mgr services | sed '1d' | sed '2d' | cut -d':' -f 3 | sed 's/\/\///g'`

# 每一分钟上报一次Ceph集群的信息
for ((i=1;i<=2;i++))
do
        ceph_original_metrics=`curl $mgrservices:9283/metrics`
        echo "$ceph_original_metrics" | grep -E "ceph_health_status|ceph_mon_quorum_status|ceph_pool_bytes_used|ceph_cluster_total_bytes|ceph_cluster_total_used_bytes|ceph_osd_in|ceph_osd_up|ceph_osd_numpg|ceph_osd_apply_latency_ms|ceph_osd_commit_latency_ms|ceph_paxos_refresh_latency_sum|ceph_paxos_refresh_latency_count|ceph_cluster_total_bytes|ceph_cluster_total_used_bytes|ceph_cluster_total_objects|ceph_cluster_total_used_bytes|ceph_osd_stat_bytes_used|ceph_osd_stat_bytes_used|ceph_osd_stat_bytes" > /usr/local/node_exporter/ceph_simplify_metrics.txt
        sed -i '/^#/d' /usr/local/node_exporter/ceph_simplify_metrics.txt
        curl -XPOST --data-binary @/usr/local/node_exporter/ceph_simplify_metrics.txt http://$hzsrv:49091/metrics/job/$job_name/instance/$instance_name
        sleep 5
done
