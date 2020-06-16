#!/bin/bash

if [ -z "$1" ]
then
  DAY=0
else
  DAY=$1
fi

echo "--------------------------------------------------------------------------"
echo "---------- /var/log/messages"
grep "$(date +"%b %e" --date="$DAY day ago")" /var/log/messages | grep -v "rsyslogd was HUPed"
echo

echo "--------------------------------------------------------------------------"
echo "---------- /var/log/susvd.log"
grep "$(date +"%a %b %e" --date="$DAY day ago")" /var/log/susvd.log
echo

echo "--------------------------------------------------------------------------"
echo "---------- /var/log/homegear/homegear.err"
sudo grep "$(date +"%m/%d/%y" --date="$DAY day ago")" /var/log/homegear/homegear.err | grep -v "Info: Backing up database"
echo

echo "--------------------------------------------------------------------------"
echo "---------- /var/log/mosquitto/mosquitto.log"
awk -F: '{ ("date -d @"$1) | getline var; print var $2 }' /var/log/mosquitto/mosquitto.log | grep "$(date +"%a %e %b" --date="$DAY day ago")" | grep -v "Saving in-memory database to /var/lib/mosquitto/mosquitto.db."
echo

echo "--------------------------------------------------------------------------"
echo "---------- /var/log/openhab2/openhab.log"
#grep "$(date +"%Y-%m-%d" --date="$DAY day ago")" /var/log/openhab2/openhab.log | grep -v INFO
awk -v start=$(date +"%Y-%m-%d" --date="$DAY day ago") 'start == $1,/INFO/' /var/log/openhab2/openhab.log | grep -v INFO
echo

echo "--------------------------------------------------------------------------"
echo "---------- /var/log/lighttpd/error.log"
sudo grep "$(date +"%Y-%m-%d" --date="$DAY day ago")" /var/log/lighttpd/error.log
echo
