#!/bin/bash

# 调用Ceph的变量
source /usr/local/node_exporter/ceph_variable.sh

# 截取Ceph当前的状态值
ceph_health_status=`ceph -s | grep health | cut -d':' -f 2 | sed 's/ //g'`

# 检查Ceph当前的版本
cephversioninfo=`ceph --version | cut -d' ' -f 3`

# 判断Ceph是否存在recovery
ceph_recovery_status=`ceph -s | grep "recovery" | wc -l`
if [[ $ceph_recovery_status -ge 1 && $ceph_health_status != "HEALTH_OK" ]]; then
cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_recovery_error_info{error_info="recovery",ceph_cluster_recovery_error_name="$job_name"} 1
EOF
else
cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_recovery_error_info{error_info="No_ERROR",ceph_cluster_recovery_error_name="$job_name"} 0
EOF
fi

# 判断Ceph的状态值发送数据
if [ $ceph_health_status == "HEALTH_OK" ]; then
cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_health_error_info{error_info="No_ERROR",ceph_cluster_error_name="$job_name"} 0
EOF
elif [ $ceph_health_status == "HEALTH_ERR" ]; then
path=`ceph -s`
path1="${path%services:*}"
path2=`echo $path1 | sed 's/:/\n/g' | sed '1,3d'`
path3=`echo $path2`
cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_health_error_info{error_info="$path3",ceph_cluster_error_name="$job_name"} 2
EOF
else
path=`ceph -s`
path1="${path%services:*}"
path2=`echo $path1 | sed 's/:/\n/g' | sed '1,3d'`
path3=`echo $path2`
cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_health_error_info{error_info="$path3",ceph_cluster_error_name="$job_name"} 1
EOF
fi

# 发送Ceph版本信息
cat <<EOF | curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_version_info{ceph_version="$cephversioninfo"} 0
EOF
