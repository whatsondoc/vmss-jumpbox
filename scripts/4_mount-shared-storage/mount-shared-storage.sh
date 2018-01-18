#!/bin/bash

# Listing just the compute nodes
cat $HOME/nodenames.txt | grep -v jbox > $HOME/computenodenames.txt

# Setting some variables by way of user prompts

if command -v expect
then

if [ -f "$HOME/computenodenames.txt" ]
then
	read -p "Enter the username capable of sudoing commands on the remote systems: " username
	echo " "
	read -s -p "Enter the password for the user account: " password
	echo " "
	read -p "What mountpoint is being exported from this node? " exportedfs
	remotehost=$(hostname)
	echo " "
	read -p "What mountpoint do you want to create & use on the compute nodes for this mount operation? " mntpoint
	echo " "
	echo -e "We will now begin mounting $exportedfs on the compute nodes as $mntpoint over nfs for the following nodes:\n"
	cat $HOME/computenodenames.txt

	for node in $(cat $HOME/computenodenames.txt)
	do
		scripts/4_mount-shared-storage/02-mount-shared-storage.sh $node $username $password $remotehost $exportedfs $mntpoint > /dev/null
	done
else
	echo -e "The file computenodenames.txt does not exist in this directory. We cannot proceed if it's not here as it lists all compute nodes in the local network and is used as a reference.\n"
	exit
fi

else
	echo -e "expect isn't available on this system.\n\nExiting...\n"
fi
