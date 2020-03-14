#!/bin/sh

MINECRAFT_FOLDER="/home/pi/minecraft/"
SERVER="server.jar"
JAVA="/home/pi/jdk1.8.0_231/bin/java"
CONSOLE="console.fifo"
LOG="logs/latest.log"


check_file() {
	if [ -e "$1" ]
	then
		return 0
	else
		return 1
	fi
}

check_argument() {
	if [ $# -gt 0 ]
	then
		return 0
	else
		return 1
	fi
}

check_process() {
	ps aux | grep $* | grep -v grep > /dev/null 2>&1
	RESULT=$?
	if [ $RESULT -eq 0 ]
	then
		echo "running"
		return 0
	else
		echo "not running"
		return 1
	fi
}

get_process() {
	PID=`ps aux | grep $* | grep -v grep | awk '{print $2}'`
	echo $PID
	return 0
}


start() {
    FILE=$MINECRAFT_FOLDER$CONSOLE
	check_file $FILE
	RESULT=$?
	if [ $RESULT -ne 0 ]
	then
		mknod $FILE p
	fi
	PID_CONSOLE=`get_process $CONSOLE`
	PID_SERVER=`get_process $SERVER`
	if [ "$PID_CONSOLE" = "" ] && [ "$PID_SERVER" = "" ]
	then
		cd $MINECRAFT_FOLDER
		tail -f $CONSOLE | $JAVA -server -Xmx2G -Xms2G -jar $SERVER nogui > /dev/null 2>&1 &
	else
		echo "some process is already running"
	fi
	status
}

stop() {
	cmd stop
	PID=`get_process $CONSOLE`
	if [ "$PID" != "" ]
	then
		kill $PID
		sleep 3
	fi
	PID=`get_process $LOG`
	if [ "$PID" != "" ]
	then
		kill $PID
	fi
	status
}

status() {
	echo -n "Server: "
	check_process $SERVER
	echo -n "Console: "
	check_process $CONSOLE
}

log() {
	FILE=$MINECRAFT_FOLDER$LOG
	check_file $FILE
	RESULT=$?
	if [ $RESULT -eq 0 ]
	then
		tail -f $FILE
	fi
}

cmd() {
	FILE=$MINECRAFT_FOLDER$CONSOLE
	check_file $FILE
	RESULT=$?
	if [ $RESULT -eq 0 ]
	then
		check_argument $*
		RESULT=$?
		if [ $RESULT -eq 0 ]
		then
			echo $* > $FILE
		fi
	fi
}


case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	status)
		status
		;;
	log)
		log
		;;
	cmd)
		shift
		cmd $*
		;;
	*)
		echo "usage: $0 {start|stop|status|log|cmd <command> [parameter]}"
		;;
esac
