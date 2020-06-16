#!/bin/sh

homegear -e rc "print_v(\$hg->getValue($1, 1, \"STATE\"));"

