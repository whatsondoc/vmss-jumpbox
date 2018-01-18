#!/bin/bash

if command -v az > /dev/null
then
	read -p "Enter the name of the VM that we will be adding disks to: " vmname
	read -p "Enter the name of the Resource Group in which the VM exists: " rg
	read -p "Enter the size in GB of each disk: " size
	read -p "How many data disks shall we add as part of this operation? Note the max number of disks per VM: " disknum

	for i in {0..12}
	do
		az vm unmanaged-disk attach --new --vm-name $vmname --resource-group $rg --lun $i --size $size --name $vmname-datadisk-0$i
	touch ./add-data-disks.completed
else
	echo -e "This is a script that will run using the Azure CLI - it does not look as though this is installed.\n\nExiting...\n"
	exit
fi
