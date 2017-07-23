#!/usr/bin/env php
<?php
//var_dump($argv);
$max = sizeof($argv);
if (sizeof($argv) == 2) {
	print "$argv[1]\n";
} else {
	print "$argv[0] <string>\n";
}
?>
