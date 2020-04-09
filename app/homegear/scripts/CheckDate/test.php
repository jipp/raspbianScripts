#!/usr/bin/env php

<?php

require('CheckDate.php');

date_default_timezone_set('Europe/Berlin');

$checkDate = new CheckDate("bankholiday.txt");

$checkDate->printContent();

if (!$checkDate->match("2018-01-01")) {
    print "not found\n";
} else {
    print "found\n";
}

if (!$checkDate->match()) {
    print "not found\n";
} else {
    print "found\n";
}

?>
