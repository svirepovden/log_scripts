#!/bin/bash
export DIR='/home/kali'
echo $DIR
start() {
	echo "Starting traffic logging"
	echo "*/10 * * * * echo \"tshark -i any -a duration:600 -w - | gzip -9 > $DIR/file_$(date +%F__%H_%M_%S).pcapng.gz\" " | crontab -
#	echo "*/10 * * * * echo 'dHNoYXJrIC1pIGFueSAtYSBkdXJhdGlvbjo2MDAgLXcgLSB8IGd6aXAgLTkgPiAiL2hvbWUva2FsaS9maWxlXyQoZGF0ZSArJUZfXyVIXyVNXyVTKS5wY2FwbmcuZ3oiCg==' | base64 -d | bash " | sudo crontab -
	1>/dev/null 2>/dev/null tshark -i any -a duration:600 -w - | gzip -9 > $DIR/file_$(date +'%F__%H_%M_%S').pcapng.gz &
}

stop() {
	echo -e "Stopping next record session\nCurrent session is still recording" 
	#kill -TERM `ps -ef | grep -v grep | grep tshark | awk  '{ print $2 }'`
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
  *) echo "Usage : $0 <start|stop|status>"; exit 1;;
esac

exit 0
