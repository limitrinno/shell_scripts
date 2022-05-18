#!/bin/bash

# storage-23的sealed复制到g3的storage-11
while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-23/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-11/sealed/ > /home/fil/rsync/storage-23-1.log
done < /home/fil/rsync/storage-23-1.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-23/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-11/sealed/ > /home/fil/rsync/storage-23-2.log
done < /home/fil/rsync/storage-23-2.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-23/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-11/sealed/ > /home/fil/rsync/storage-23-3.log
done < /home/fil/rsync/storage-23-3.txt &

# storage-24的sealed复制到g3的storage-12
while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-24/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-12/sealed/ > /home/fil/rsync/storage-24-1.log
done < /home/fil/rsync/storage-24-1.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-24/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-12/sealed/ > /home/fil/rsync/storage-24-2.log
done < /home/fil/rsync/storage-24-2.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-24/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-12/sealed/ > /home/fil/rsync/storage-24-3.log
done < /home/fil/rsync/storage-24-3.txt &
