#!/bin/bash

hostname=$1
username=$2

scp $HOME/users.txt $username@$hostname:/home/$username/
ssh -t $username@$hostname "sudo newusers users.txt"

touch $HOME/5_create-users.completed
