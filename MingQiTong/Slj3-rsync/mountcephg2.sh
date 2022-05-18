#!/bin/bash

# Ubuntu sudo
echo "password" |sudo -S ls > /dev/null

#sudo mount -t ceph 10.40.193.13,10.40.193.14,10.40.193.15:6789:/ /mnt/cephfs-f01773349-g2 -o name=admin,secret=AQCfJkVizc2HHhAAtbVRlF9NdYLsCkfBEdcP6w==,noatime,nodiratime
sudo mount -t ceph 10.40.195.1,10.40.195.2,10.40.195.3:6789:/ /mnt/cephfs-f01773349-g3 -o name=admin,secret=AQDuwHtiNrTvHRAAJQSZb4hfgfy6iv8LcRH1TA==,noatime,nodiratime
