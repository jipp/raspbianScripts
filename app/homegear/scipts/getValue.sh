#!/bin/sh

homegear -e rc "\$hg->getValue($1, 1, \"STATE\");"
