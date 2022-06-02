#!/bin/bash

# Pushgateway Job显示名称
job_name="TestStable"
# 获取主机IP
instance_name=`ip a | grep inet | grep -vE "127.0.0.1|inet6|docker" | awk '{print $2}' | tr -d "addr:" | cut -d'/' -f 1`
