#!/usr/bin/env python

import sys, psutil, datetime, smbus, os

if len(sys.argv) != 2:
        print '{} <flag>'.format(sys.argv[0])
        sys.exit()

if sys.argv[1] == "boot":
	print datetime.datetime.fromtimestamp(psutil.boot_time()).strftime("%d.%m.%Y %H:%M:%S")
elif sys.argv[1] == "mem":
	print psutil.virtual_memory().percent
elif sys.argv[1] == "disk":
	print psutil.disk_usage('/').percent
elif sys.argv[1] == "cpu":
	print psutil.cpu_percent(interval=1)
elif sys.argv[1] == "vcc":
	bus = smbus.SMBus(1)
	print bus.read_word_data(0x0F,0xD0)
elif sys.argv[1] == "temp":
	print float(os.popen('cat /sys/class/thermal/thermal_zone0/temp').readline())/1000
