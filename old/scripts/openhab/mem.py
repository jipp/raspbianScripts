#!/usr/bin/env python

import sys,psutil

if len(sys.argv) != 2:
	print '{} <username>'.format(sys.argv[0])
	sys.exit()

mem = 0

for proc in psutil.process_iter():
    try:
        pinfo = proc.as_dict(attrs=['memory_percent', 'username'])
    except psutil.NoSuchProcess:
        pass
    else:
        if sys.argv[1] == pinfo['username']:
           mem += pinfo['memory_percent']

print mem
