#!/usr/bin/env php

<?php

require('Ical.php');

date_default_timezone_set('Europe/Berlin');

//$ical = new Ical("feiertage_nordrhein-westfalen_2018.ics");
$ical = new Ical("ferien_nordrhein-westfalen_2018.ics");

//$ical->printContent();
//$found = $ical->match("20180101");
//$found = $ical->match("20181015");
$found = $ical->match();
if ($found) {
	print($found."\n");
} else {
	print("not found"."\n");
}

?>
