#!/bin/bash

which homegear > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo OK
else
	echo NOK
fi
