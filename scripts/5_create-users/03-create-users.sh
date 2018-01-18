#!/bin/bash

hostname=$1
username=$2

scp users.txt $username@$hostname:/home/$username/
ssh -t $username@$hostname "sudo newusers users.txt"

touch ./create-users.completed
