#!/bin/bash

# 调用Ceph的变量
source /usr/local/node_exporter/ceph_variable.sh

# 向Pushgateway服务器121.196.127.74:49091,发送模式1为恢复模式，2为业务模式
cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
ceph_business_mode{business_mode_info="Recovery Mode"} 1
EOF

# 向Pushgateway服务器121.196.127.74:49091,发送模式1为恢复模式，2为业务模式
#cat <<EOF |  curl --data-binary @- http://121.196.127.74:49091/metrics/job/$job_name/instance/$instance_name
#ceph_business_mode{business_mode_info="Work Mode"} 2
#EOF
