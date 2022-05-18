#!/bin/bash
    ch_node_exporter=`ls /usr/local | grep 'node_exporter' | wc -l`
    ch_node_exporter=`ls /usr/lib/systemd/system | grep 'node_exporter' | wc -l`
    mkdir -p /usr/local/node_exporter
if [[ $ch_node_exporter == '0' && $ch_node_exporter == '0' ]];then
    cd ~ && yum -y install wget && wget --no-check-certificate https://soft.2331314.xyz/app/prometheus/node_exporter-1.3.1.linux-amd64.tar.gz && tar -zxvf node_exporter-1.3.1.linux-amd64.tar.gz && mv node_exporter-1.3.1.linux-amd64 /usr/local/node_exporter && rm -rf node_exporter-1.3.1.linux-amd64.tar.gz
    cat >> /usr/lib/systemd/system/node_exporter.service << EOF
[Unit]
Description=node_export
Documentation=https://github.com/prometheus/node_exporter
After=network.target
[Service]
Type=simple
User=root
ExecStart= /usr/local/node_exporter/node_exporter
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart node_exporter.service && systemctl enable node_exporter.service
else
    read -p "需要清理现存文件，默认删除/usr/local/node_exporter*和/usr/lib/systemd/system/node_exporter*和/root/下node_exporter相关>的文件
    同意输入1，不同意输入0 : " nodeexporternum
    case $nodeexporternum in
    1)  rm -rf /usr/local/node_exporter* && rm -rf /root/node_exporter* && rm -rf /usr/lib/systemd/system/node_exporter* && bash /root/shell/install_node_exporter.sh;;
    0)  exit;
    esac
fi
