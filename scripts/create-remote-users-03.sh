#!/bin/bash

adminuser=<username>
hostname=$1

scp users.txt $adminuser@$hostname:/home/$adminuser/
ssh -t $adminuser@$hostname "sudo newusers users.txt"
