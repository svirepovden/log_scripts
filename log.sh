#!/bin/bash


# Log.sh: script which setups command line logging
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


# Getting users and define home folders
# 
#
cat /etc/passwd | grep sh$ | cut -d: -f 1,6 > ./tmp
for string in $(cat ./tmp) 
do
    echo "$string"
	if [[ $(echo $string | cut  -d: -f 2 | grep -e '^/home' -e '^/root') ]]; then
	echo $string >> ./tmp_users
    fi
done
rm ./tmp

user_dirs=($(cat tmp_users | cut -d: -f 2))
rc_files=('.zshrc' '.bashrc')

echo "folowing files will be changed:"
for dir in ${user_dirs[@]}; do
	for rc in ${rc_files[@]}; do
		echo " - $dir/$rc"
	done
done

read -e -p "Continue (yes/no): " ANSWER
if [[ "$ANSWER" == 'yes' ]]; then
	for dir in ${user_dirs[@]}; do
		for rc in ${rc_files[@]}; do
			echo "$dir/$rc"
			if [ -f "$dir/$rc" ]; then
				echo -e "\nFILE $dir/$rc \n"
				if grep 'cmd logging' "$dir/$rc"
				then
					echo "$dir/$rc Already changed"
				else
					echo "backing up $dir/$rc to $dir/$rc.back"
					cp -i "$dir/$rc" "$dir/$rc.back_before_logsh"
					echo "adding log instructuons"
					cat ./to_rc >> "$dir/$rc"
				fi
			else echo "File $dir/$rc not found"
			fi
			if [ ! -d "$dir/cmd_logs" ]; then
				echo "creating $dir/cmd_logs"
				mkdir "$dir/cmd_logs"
			else echo "$dir/cmd_logs already exists"
			fi
		done
	done
	rm -i tmp_users
		
fi		
