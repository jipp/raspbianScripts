#!/bin/sh

tar -zcpf homegear-backup.tar.gz --exclude="*.so" /etc/homegear /var/lib/homegear /data/homegear
