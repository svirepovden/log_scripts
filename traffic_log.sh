#!/bin/bash
export DIR='/root'
echo $DIR
start() {
	echo "Starting traffic logging"
	export filename="$DIR/file_$(date +%F__%H_%M_%S).pcapng.gz"
	echo "*/10 * * * * echo \"tshark -i any -a duration:600 -w - | gzip -9 > $filename\" " | crontab -
	1>/dev/null 2>/dev/null tshark -i any -a duration:600 -w - | gzip -9 > "$filename" &
}

stop() {
	echo -e "Stopping next record session\nCurrent session is still recording" 
	crontab -r
	
}

status() {
	if (( $(ps -ef | grep -v grep | grep tshark | wc -l) > 0 )); then
		echo "Traffic is recording"
		echo "`ps -ef | grep -v grep | grep tshark`"
	else
		echo "Service is down"
	fi
}

case $1 in
  start|stop|status) $1;;
  *) echo -e "Usage : $0 <start | stop | status>\nTraffic is recorded every 10 minutes\nUser is important!"; exit 1;;
esac

exit 0
