#!/bin/bash

# sealed 备份
nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-19/sealed/ /mnt/cephfs-f01773349-g3/ec/storage-07/sealed/ > /home/fil/sync/storage-07.log &

nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-20/sealed/ /mnt/cephfs-f01773349-g3/ec/storage-08/sealed/ > /home/fil/sync/storage-08.log &

nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-21/sealed/ /mnt/cephfs-f01773349-g3/ec/storage-09/sealed/ > /home/fil/sync/storage-09.log &

nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-22/sealed/ /mnt/cephfs-f01773349-g3/ec/storage-10/sealed/ > /home/fil/sync/storage-10.log &

nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-23/sealed/ /mnt/cephfs-f01773349-g3/ec/storage-11/sealed/ > /home/fil/sync/storage-11.log &

nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-24/sealed/ /mnt/cephfs-f01773349-g3/ec/storage-12/sealed/ > /home/fil/sync/storage-12.log &
