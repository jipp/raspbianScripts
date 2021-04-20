<?php

class Ical {
	private $events = array();

	public function __construct(...$files) {
		$created = true;
		if (count($files) != 0) {
			foreach($files as $file) {
				if (!$this->parse($file)) {
					$created = false;
				}
			}
		} else {
			$created = false;
		}
		if ($created == false) {
			exit();
		}
		return true;
	}

	function __destruct() {
	}

	private function parse($file) {
		$string = $this->fileRead($file);
		if (isset($string)) {
			$block = explode("BEGIN", $string);
			foreach($block as $key => $value) {
				$dates[$key] = explode("\n", $value);
			}
			foreach($dates as $key => $value) {
				$keyCount = count($this->events);
				foreach($value as $subKey => $subValue) {
					$entry = explode(":", $subValue, 2);
					if (isset($entry[1])) {
						$this->events[$keyCount][$entry[0]] = $entry[1];
					}
				}
			}
			return true;
		} else {
			return false;
		}
	}

	private function fileRead($file) {
		if ($this->fileExist($file)) {
			$string = file_get_contents($file);
			if ($string === false) {
				print("error file: ".$file."\n");
				return false;
			}
			return $string;
		} else {
			return null;
		}
	}

	private function fileExist($file) {
		if (!file_exists($file)) {
			print("file does not exist: ".$file."\n");
			return false;
		} else {
			return true;
		}
	}

	public function match($date = null) {
		if (!isset($date)) {
			$date = date("Ymd");
		}
		foreach($this->events as $value) {
			if (isset($value["SUMMARY"])) {
				if ($date >= $value["DTSTART;VALUE=DATE"] and $date < $value["DTEND;VALUE=DATE"]) {
					return $value["SUMMARY"];
				}
			}
		}
		return null;
	}

	public function printContent() {
		var_dump($this->events);
	}
}

?>
