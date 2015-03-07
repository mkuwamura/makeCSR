#!/usr/bin/expect

#author @mkuwamura
# usage ./csr.sh "JP" "Osaka" "Osaka-shi" "MK JAPAN CO.,LTD." "Systems Development Division" "www.example.jp" you_failname

set timeout 5
set C [lindex $argv 0]
set S [lindex $argv 1]
set L [lindex $argv 2]
set O [lindex $argv 3]
set OU [lindex $argv 4]
set CN [lindex $argv 5]
set FILENAME [lindex $argv 6]

spawn openssl sha1 * |tee rand.dat
spawn openssl genrsa -rand rand.dat -out $FILENAME.key -des3 2048

expect "Enter pass phrase"
send "00000000\n"
expect "Verifying - Enter pass phrase"
send "00000000\n"
interact


spawn openssl req -new -key $FILENAME.key -out $FILENAME.csr
expect "Enter pass phrase"
send "00000000\n"
expect "Country Name"
send "$C\n"
expect "State or Province Name "
send "$S\n"
expect "Locality Name"
send "$L\n"
expect "Organization Name"
send "$O\n"
expect "Organizational Unit Name"
send "$OU\n"
expect "Common Name "
send "$CN\n"
expect "Email Address "
send "\n"
expect "A challenge password "
send "\n"
expect "An optional company name"
send "\n"
send "\n"
sleep 2
expect "]$"

spawn openssl rsa -in $FILENAME.key -out $FILENAME.key
expect "Enter pass phrase for $FILENAME.key:"
send "00000000\n"

expect "]$"

spawn openssl req -noout -text -in $FILENAME.csr

expect "]$"
spawn cat $FILENAME.csr
interact