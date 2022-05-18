#!/bin/bash

# 调用Ceph的变量
source /usr/local/node_exporter/ceph_variable.sh
# 获取当前机器的名称
hostname_name=`hostname -f | cut -d'.' -f1`

# 每15秒推送一次机器数据到pushgateway
for ((i=1;i<=4;i++))
do
        sleep 2
        ceph_base_metrics=`curl 127.0.0.1:9100/metrics`
        echo "$ceph_base_metrics" | curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
        sleep 13
done
