#!/bin/bash

# storage-19的sealed复制到g3的storage-07
while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-19/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-07/sealed/ > /home/fil/rsync/storage-19-1.log
done < /home/fil/rsync/storage-19-1.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-19/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-07/sealed/ > /home/fil/rsync/storage-19-2.log
done < /home/fil/rsync/storage-19-2.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-19/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-07/sealed/ > /home/fil/rsync/storage-19-3.log
done < /home/fil/rsync/storage-19-3.txt &

# storage-20的sealed复制到g3的storage-08
while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-20/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-08/sealed/ > /home/fil/rsync/storage-20-1.log
done < /home/fil/rsync/storage-20-1.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-20/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-08/sealed/ > /home/fil/rsync/storage-20-2.log
done < /home/fil/rsync/storage-20-2.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-20/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-08/sealed/ > /home/fil/rsync/storage-20-3.log
done < /home/fil/rsync/storage-20-3.txt &
