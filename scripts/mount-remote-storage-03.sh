#!/bin/bash

mntpoint=$6
exportedfs=$5
remotehost=$4
password=$3
username=$2
hostname=$1
remotefs=nfs

ssh -t $username@$hostname << EOF
	sudo mkdir $mntpoint
	sudo mount -t $remotefs $remotehost:$exportedfs $mntpoint
	echo "$remotehost:$exportedfs	$mntpoint	$remotefs	defaults 0 0" | sudo tee --append /etc/fstab
EOF
