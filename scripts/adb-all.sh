#!/usr/bin/env bash
#
# Run a command on each adb connected device (adb fail with INSTALL_FAILED_UPDATE_INCOMPATIBLE if multiple devices are connected)
#
# Sample: 
# To uninstall an apk on every device: 
#    $ sh adb-all.sh uninstall my.apk 

adb devices | while read line
do
    if [ ! "$line" = "" ] && [ `echo $line | awk '{print $2}'` = "device" ]
    then
        device=`echo $line | awk '{print $1}'`
        echo "$device $@ ..."
        adb -s $device $@
    fi
done