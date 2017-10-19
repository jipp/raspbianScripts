#!/bin/sh

timestamp=`date +%Y%m%d%H%M`
backupName=backup_$timestamp
#backupFolder=$HOME/$backupName
backupFolder=/root/$backupName


echo "> create backup folder:\n\t$backupFolder"
sudo mkdir -p $backupFolder

system="/boot /etc"
echo -n "> backup system:\n\t$system\n\t"
sudo tar cPzf $backupFolder/system.tgz $system
sudo du -sh $backupFolder/system.tgz

lighttpd="/etc/lighttpd /var/www"
echo -n "> backup lighttpd:\n\t$lighttpd\n\t"
sudo tar cPzf $backupFolder/lighttpd.tgz $lighttpd
sudo du -sh $backupFolder/lighttpd.tgz

openhab2="/etc/openhab2 /var/lib/openhab2"
echo -n "> backup openhab2:\n\t$openhab2\n\t"
sudo tar cPzf  $backupFolder/openhab2.tgz $openhab2
sudo du -sh $backupFolder/openhab2.tgz

#homegear="/etc/homegear /var/lib/homegear"
#echo -n "> backup homegear:\n\t$homegear\n\t"
#sudo tar cPzf $backupFolder/homegear.tgz $homegear
#sudo du -sh $backupFolder/homegear.tgz

susv="/opt/susvd"
echo -n "> backup susv:\n\t$susv\n\t"
sudo tar cPzf $backupFolder/susvd.tgz $susv
sudo du -sh $backupFolder/susvd.tgz

mosquitto="/etc/mosquitto"
echo -n "> backup mosquitto:\n\t$mosquitto\n\t"
sudo tar cPzf $backupFolder/mosquitto.tgz $mosquitto
sudo du -sh $backupFolder/mosquitto.tgz

pi="/home/pi"
echo -n "> backup pi:\n\t$pi\n\t"
sudo tar cPzf $backupFolder/pi.tgz $pi
sudo du -sh $backupFolder/pi.tgz

echo -n "> summary\n\t"
sudo du -sh $backupFolder

echo -n "> mount usbstick\n\t"
#sudo mount /dev/sda1 /media
sudo mount UUID="9fe8d4e4-ef78-45ec-a276-a9cdef3de064" /media
sudo df -h | grep "/media"

echo -n "> copy backupfolder: $backupFolder\n\t"
sudo tar cPf /media/$backupName.tar $backupFolder
sudo du -sh /media/$backupName.tar

echo -n "> umount usbstick\n\t"
sudo df -h | grep "/media"
sudo umount /media

echo "> finished"
