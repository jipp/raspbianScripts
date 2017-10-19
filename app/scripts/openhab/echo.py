#!/usr/bin/env python

import sys

if len(sys.argv) != 2:
        print '{} <string>'.format(sys.argv[0])
        sys.exit()

print sys.argv[1]
