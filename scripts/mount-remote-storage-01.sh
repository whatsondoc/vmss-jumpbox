#!/bin/bash

# We just want to list the remote compute nodes (not the jumpbox/head node):
cat nodenames.txt | grep -v jbox > computenodenames.txt

for i in $(cat computenodenames.txt); do
	./mount-shared-storage-02.sh $i
done
