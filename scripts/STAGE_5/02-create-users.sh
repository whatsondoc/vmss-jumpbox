#!/usr/bin/expect

set timeout -1

set username [lindex $argv 2]
set password [lindex $argv 1]
set hostname [lindex $argv 0]

spawn ./03-create-users.sh $hostname $username

expect "*?assword*:"

send "$password\r";

interact
