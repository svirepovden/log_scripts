#!/bin/bash
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
					cp "$dir/$rc" "$dir/$rc.back"
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
fi		
