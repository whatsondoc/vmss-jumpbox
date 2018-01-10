#!/usr/bin/expect

set timeout -1

set user "<username>"
set password "<password>"
set hostname [lindex $argv 0]

spawn ./create-remote-users-03.sh $hostname

expect "*?assword*:"

send "$password\r";

interact

