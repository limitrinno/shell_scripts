#!/bin/bash

# Pushgateway Job显示名称
job_name="Test"
# 获取主机IP
instance_name=`ip a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" | cut -d'/' -f 1`
