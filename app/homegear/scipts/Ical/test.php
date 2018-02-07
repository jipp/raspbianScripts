#!/usr/bin/env php

<?php

require('Ical.php');

date_default_timezone_set('Europe/Berlin');

$ical = new Ical("feiertage_nordrhein-westfalen_2018.ics");

//$ical->printContent();

?>
