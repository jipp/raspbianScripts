#!/usr/bin/env php

<?php
$hg = new \Homegear\Homegear();
$hg->removeEvent("Remote 1");
$hg->removeEvent("Remote 2");
$hg->removeEvent("Remote 3");
$hg->removeEvent("Remote 4");
$hg->removeEvent("Felix Decke");
$hg->removeEvent("Felix Schreibtisch");

#$hg->addEvent(array("TYPE" => 0, "ID" => "Remote 1", "PEERID" => 6, "PEERCHANNEL" => 1, "VARIABLE" => "PRESS_SHORT", "TRIGGER" => 8, "TRIGGERVALUE" => true, "EVENTMETHOD" => "setValue", "EVENTMETHODPARAMS" => Array(2, 1, "STATE", "!")));
#$hg->addEvent(array("TYPE" => 0, "ID" => "Remote 2", "PEERID" => 6, "PEERCHANNEL" => 2, "VARIABLE" => "PRESS_SHORT", "TRIGGER" => 8, "TRIGGERVALUE" => true, "EVENTMETHOD" => "setValue", "EVENTMETHODPARAMS" => Array(4, 1, "STATE", "!")));
#$hg->addEvent(array("TYPE" => 0, "ID" => "Remote 3", "PEERID" => 6, "PEERCHANNEL" => 3, "VARIABLE" => "PRESS_SHORT", "TRIGGER" => 8, "TRIGGERVALUE" => true, "EVENTMETHOD" => "setValue", "EVENTMETHODPARAMS" => Array(5, 1, "STATE", "!")));
#$hg->addEvent(array("TYPE" => 0, "ID" => "Remote 4", "PEERID" => 6, "PEERCHANNEL" => 4, "VARIABLE" => "PRESS_SHORT", "TRIGGER" => 8, "TRIGGERVALUE" => true, "EVENTMETHOD" => "setValue", "EVENTMETHODPARAMS" => Array(3, 1, "STATE", "!")));
#$hg->addEvent(array("TYPE" => 0, "ID" => "Felix Decke", "PEERID" => 11, "PEERCHANNEL" => 1, "VARIABLE" => "PRESS_SHORT", "TRIGGER" => 8, "TRIGGERVALUE" => true, "EVENTMETHOD" => "setValue", "EVENTMETHODPARAMS" => Array(12, 1, "STATE", "!")));
#$hg->addEvent(array("TYPE" => 0, "ID" => "Felix Schreibtisch", "PEERID" => 11, "PEERCHANNEL" => 2, "VARIABLE" => "PRESS_SHORT", "TRIGGER" => 8, "TRIGGERVALUE" => true, "EVENTMETHOD" => "setValue", "EVENTMETHODPARAMS" => Array(7, 1, "STATE", "!")));

print_r($hg->listDevices())
print_r($hg->listEvents())
