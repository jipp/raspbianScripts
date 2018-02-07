<?php

class Ical {

	private $dates = array();

	public function __construct($file = null) {
		if (isset($file)) {
			if ($this->parse($file)) {
				return true;
			} else {
				exit();
			}
		}
	}

	function __destruct() {
	}

	public function parse($file) {
		if ($this->fileRead($file)) {
			$block = explode("BEGIN", $this->string);
			foreach($block as $key => $value) {
				$this->dates[$key] = explode("\n", $value);
			}
			foreach($this->dates as $key => $value) {
				foreach($value as $key => $value1) {
//					$woke = explode(":", $value1, 2);
//					//var_dump(explode(":", $value1, 2));
					var_dump($value1);
				}
			}
			return true;
		} else {
			return false;
		}
	}

	public function fileRead($file) {
		if ($this->fileExist($file)) {
			$this->string = file_get_contents($file);
			if ($this->string === false) {
				print("error file: ".$file."\n");
				return false;
			}
			return true;
		} else {
			return false;
		}
	}

	public function fileExist($file) {
		if (!file_exists($file)) {
			print("file does not exist: ".$file."\n");
			return false;
		} else {
			return true;
		}
	}

	public function match($date = null) {
		if (!isset($date)) {
			$date = date("Y-m-d");
		}
		foreach($this->dates as $value) {
			if (count($value) == 1) {
				if ($date == $value[0]) {
					return true;
				}
			} elseif (count($value) == 2) {
				if ($date >= $value[0] and $date <= $value[1]) {
					return true;
				}
			}
		}
		return false;
	}

	public function printContent() {
		var_dump($this->dates);
	}

}

?>
