#!/bin/bash

# Setting some variables by way of user prompts

if [ -f "nodenames.txt" ]
then
	read -p "Enter the username capable of sudoing commands on the remote systems: " username
	echo ""
	read -s -p "Enter the password for the user account: " password
	echo ""
	read -p "What mountpoint is being exported from this node? " exportedfs
	remotehost=$(cat hostname)
	echo ""
	read -p "What mountpoint do you want to create &use on the compute nodes for this mount operation? " mntpoint
	echo ""
	read -p 'We will now begin mounting $exportedfs on the compute nodes as $mntpoint over nfs for the following nodes:"
	cat computenodenames.txt

	# We just want to list the remote compute nodes (not the jumpbox/head node):

	cat nodenames.txt | grep -v jbox > computenodenames.txt

	for node in $(cat computenodenames.txt)
	do
		./mount-shared-storage-02.sh $node $username $password $remotehost $exportedfs $mntpoint
	done
else
	echo -e "The file nodenames.txt does not exist in this directory. We cannot proceed if it's not here as it lists all compute nodes in the local network and is used as a reference.\n"
	exit
fi

