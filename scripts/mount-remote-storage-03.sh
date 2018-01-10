#!/bin/bash

mntpoint=/mnt/nfs
remotehost=hpcvmssrg43sbw6r455cjbox
exportedfs=/mnt/sharedstorage
remotefs=nfs


sudo mkdir $mntpoint

sudo mount -t $remotefs $remotehost:$exportedfs $mntpoint

sudo echo "$remotehost:$exportedfs	$mntpoint	$remotefs	defaults 0 0" >> /etc/fstab
