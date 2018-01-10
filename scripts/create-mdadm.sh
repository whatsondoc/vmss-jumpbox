#!/bin/bash

mdadmlocalmnt=/mnt/sharedstorage
filesystem=ext4
ipprefix="172.16.32.0"

read -p "Please run as root...\n\n"


# Capture all disks on a system that aren't the local OS & ephemeral disks:

ls /dev/sd* | grep -v sda | grep -v sdb > /tmp/disks-for-mdadm.list


# Counting the number of disks we have

disknum=$(cat /tmp/disks-for-mdadm.list | wc -l)


# Creating the mdadm array

mdadm --create /dev/md0 --level=0 --chunk=256 --raid-devices=$disknum `cat /tmp/disks-for-mdadm.list` --verbose >> /tmp/mdadm-array-creation.output


# Creating a filesystem on the mdadm array

mkfs.$filesystem /dev/md0


# Mount the newly created filesystem to a directory

mkdir $mdadmlocalmnt
mount /dev/md0 $mdadmlocalmnt

# Making it persistent

echo "/dev/md0	$mdadmlocalmnt	$filesystem	defaults	0 0" >> /etc/fstab


# Export the filesystem over NFS

service nfs start
chkconfig nfs on

echo "$mdadmlocalmnt $ipprefix(rw,sync)" >> /etc/exports
exportfs -a 
