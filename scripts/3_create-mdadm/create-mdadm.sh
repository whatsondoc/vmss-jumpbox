#!/bin/bash

if [[ $USER != "root" ]] 
then
	echo -e "\n...Please run this script as root...\n"
	exit
else

# Storing some data as variables from user prompts:

	echo ""
	read -p "Where do you want to mount the mdadm array? " mdadmlocalmnt

	echo ""
	read -p "Which filesystem would you like to use? " filesystem

	echo ""
	read -p "Enter the IP prefix for the network that will have access to the exported filesystem.

For example, type 172.16.32 to allow all hosts on that network segment mount access (we will add the wildcard): " ipprefix

# Please only use the prefix - specify the first 3 octets to allow access to all addresses in that subnet (wildcarded below)
	echo ""


# Capture all disks on a system that aren't the local OS & ephemeral disks:

	ls /dev/sd* | grep -v sda | grep -v sdb > /tmp/disks-for-mdadm.list


# Counting the number of disks we have

	disknum=$(cat /tmp/disks-for-mdadm.list | wc -l)


# Creating the mdadm array

	array=/dev/md0

	mdadm --create $array --level=0 --chunk=256 --raid-devices=$disknum `cat /tmp/disks-for-mdadm.list` --verbose >> /tmp/mdadm-array-creation.output


# Creating a filesystem on the mdadm array

	mkfs.$filesystem $array


# Mount the newly created filesystem to a directory

	mkdir $mdadmlocalmnt
	mount $array $mdadmlocalmnt

# Making it persistent

	diskuuid=$(blkid $array)
	echo "$diskuuid	$mdadmlocalmnt	$filesystem	defaults	0 0" >> /etc/fstab


# Export the filesystem over NFS

	service nfs start
	chkconfig nfs on

	echo "$mdadmlocalmnt $ipprefix.*(rw,sync)" >> /etc/exports
	exportfs -a
	chmod 777 $mdadmlocalmnt

# Creating completed marker file

	touch $HOME/3_create-mdadm.completed

fi
