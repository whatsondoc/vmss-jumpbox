#!/bin/bash

users=users.txt
nodenames=nodenames.txt

read -p "...Please ensure there is a completed $users & $nodenames file in this directory. $users needs input..."
echo ""

if command -v expect && command -v newusers
then

	if [ -f $users ] && [ -f $nodenames ]
	then
		# We just want to list the remote compute nodes (not the jumpbox/head node):
		cat nodenames.txt | grep -v jbox > computenodenames.txt

		read -p "Enter the username to connect to the remote machines (this user needs to exist on the remote node(s)): " username
		read -s -p "Enter the sudo password for the remote machines: " password
		echo -e "\n"

		for i in $(cat computenodenames.txt)
		do
			./02-create-users.sh $i $password $username
		done
	else
		echo -e "Either $users or $nodenames is missing in this directory, and we cannot continue without both...\n"
	fi
else
	echo -e "Either expect or newusers (or both) is not installed on this system, and is needed.\nExiting...\n"
fi
