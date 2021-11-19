#!/bin/bash


# Traffic_log.sh: script which setups all traffic record to pcap
#
# Copyright (c) 2021 Denis Svirepov 
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE. 
#
# Author: Denis Svirepov svirepovden@gmail.com


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
