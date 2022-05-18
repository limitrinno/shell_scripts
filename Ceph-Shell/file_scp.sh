#!/bin/bash

while read line
do
	# 传送一键安装node_exporter的脚本
	#scp /root/shell/install_node_exporter.sh root@$line:/root/shell
	# 传送node_exporter的上传信息脚本
	#scp /usr/local/node_exporter/ceph_cluster_machine_info.sh root@$line:/usr/local/node_exporter
	# 传送机器信息配置表
	scp /usr/local/node_exporter/storage_machine_info.sh root@$line:/usr/local/node_exporter
	scp /usr/local/node_exporter/get_storage_disklist.sh root@$line:/usr/local/node_exporter
#	scp /usr/local/node_exporter/ceph_variable.sh root@$line:/usr/local/node_exporter
	# node_exporter的服务进程传送到其他的服务器
	#scp /lib/systemd/system/node_exporter.service root@$line:/lib/systemd/system/
done < ip.txt
