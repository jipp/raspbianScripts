#!/usr/bin/env python

import sys,psutil

if len(sys.argv) != 2:
	print '{} <username>'.format(sys.argv[0])
	sys.exit()

mem = 0

for i in psutil.pids():
	try:
		p = psutil.Process(i)
	except psutil.NoSuchProcess:
		pass
	else:
		if sys.argv[1] == p.username():
			mem += p.memory_percent()

print mem
