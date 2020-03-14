#!/usr/bin/expect

set timeout 60

set server xxxx
set port yyy
set username zzzz

stty -echo
send_user "Password: "
expect_user -re "(.*)\n"
set password $expect_out(1,string)
stty echo

log_user 0
spawn $env(SHELL)
send "ssh $username@$server -p $port\r"

expect "yes/no" {
	send "yes\r"
	expect "Enter passphrase for key" { send "$password\r" }
} "Enter passphrase for key" { send "$password\r" }


log_user 1
expect "*$ " { send "./server.sh $argv\r" }
expect "*$ " { send "exit\r" }
close

send_user "\r"
