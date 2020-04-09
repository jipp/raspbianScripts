#!/usr/bin/env php

<?php

require('Ical.php');

date_default_timezone_set('Europe/Berlin');

//$ical = new Ical();

$ical = new Ical("feiertage_nordrhein-westfalen_2018.ics");

$found = $ical->match("20180101");
print($found."\n");
$found = $ical->match("20181015");
print($found."\n");
$found = $ical->match();
print($found."\n");

//if ($found) {
//	print($found."\n");
//} else {
//	print("not found"."\n");
//}

$ical = new Ical("ferien_nordrhein-westfalen_2018.ics", "feiertage_nordrhein-westfalen_2018.ics");

$found = $ical->match("20180101");
print($found."\n");
$found = $ical->match("20181015");
print($found."\n");
$found = $ical->match();
print($found."\n");

//$ical->printContent();

?>
