#!/usr/bin/expect

set timeout -1

set mntpoint [lindex $argv 5]
set exportedfs [lindex $argv 4]
set remotehost [lindex $argv 3]
set password [lindex $argv 2]
set username [lindex $argv 1]
set hostname [lindex $argv 0]

spawn ./create-remote-users-03.sh $hostname $username $password $remotehost $exportedfs $mntpoint

expect "*?assword*:"

send "$password\r";

interact

