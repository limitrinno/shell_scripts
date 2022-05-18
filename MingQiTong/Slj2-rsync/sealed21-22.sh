#!/bin/bash

# storage-21的sealed复制到g3的storage-09
while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-21/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-09/sealed/ > /home/fil/rsync/storage-21-1.log
done < /home/fil/rsync/storage-21-1.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-21/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-09/sealed/ > /home/fil/rsync/storage-21-2.log
done < /home/fil/rsync/storage-21-2.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-21/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-09/sealed/ > /home/fil/rsync/storage-21-3.log
done < /home/fil/rsync/storage-21-3.txt &

# storage-22的sealed复制到g3的storage-10
while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-22/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-10/sealed/ > /home/fil/rsync/storage-22-1.log
done < /home/fil/rsync/storage-22-1.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-22/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-10/sealed/ > /home/fil/rsync/storage-22-2.log
done < /home/fil/rsync/storage-22-2.txt &

while read line
do
	nohup rsync -av --progress --inplace /mnt/cephfs-f01773349-g2/ec2/storage-22/sealed/$line /mnt/cephfs-f01773349-g3/ec/storage-10/sealed/ > /home/fil/rsync/storage-22-3.log
done < /home/fil/rsync/storage-22-3.txt &
