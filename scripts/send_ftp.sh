#!/bin/sh

export ftp_proxy="http://192.168.55.3:3129"

HOST=$1
USER=$2
PASSWD=$3
FILE=$4

ftp -n -v $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
bin
tick
put $FILE
quit
END_SCRIPT
exit 0
