#!/bin/sh

homegear -e rc "\$hg->setValue($1, 1, \"STATE\", $2);"
