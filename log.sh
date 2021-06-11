#!/bin/bash
echo "$SHELL"
user_dirs=("/root/" "/home/kali/")

if [[ "$SHELL" == '/usr/bin/zsh' ]]; then
	echo "you are using zsh"
	echo "folowing files will be changed:"
	echo " - /etc/zsh/zshrc"
	echo " - ${user_dirs[0]}.zshrc"
	echo " - ${user_dirs[1]}.zshrc"
	read -e -p "Continue (yes/no): " ANSWER
	if [[ "$ANSWER" == 'yes' ]]; then
		echo -e "\nFILE /etc/zsh/zshrc\n"
		if grep 'cmd logging' /etc/zsh/zshrc
		then
			echo "Already changed"
		else
			cp /etc/zsh/zshrc /etc/zsh/zshrc.back
			echo 'setopt incappendhistory #cmd logging' >> /etc/zsh/zshrc &&
			echo 'precmd (){ #cmd logging' >> /etc/zsh/zshrc &&
			echo '	command="$(fc -n -e - -l -1)" #cmd logging' >> /etc/zsh/zshrc &&
			echo '	logger -p local1.notice -t zsh -i "$USER input: $command" #cmd logging' >> /etc/zsh/zshrc && 
			echo '} #cmd logging' >> /etc/zsh/zshrc
			echo 'preexec() { #cmd logging' >> /etc/zsh/zshrc
			echo 'exec > > (tee ~/.command.out&) #cmd logging' >> /etc/zsh/zshrc
			echo 'output=$(cat ~/.command.out) #cmd logging' >> /etc/zsh/zshrc
			echo 'logger -p local1.notice -t zsh -i "$USER output: $output" #cmd logging' >> /etc/zsh/zshrc
		fi

		echo -e "\nFILE /root/.zshrc\n"
		if grep 'cmd logging' /root/.zshrc
		then
			echo "Already changed"
		else
			cp /root/.zshrc /root/.zshrc.back
			sed '/precmd.*/a\\tcommand="$(fc -n -e - -l -1)" #cmd logging\n\tlogger -p local1.notice -t zsh -i "$USER : $command" #cmd logging' /root/.zshrc.back > /root/.zshrc
			echo 'preexec() { #cmd logging' >> /root/.zshrc
			echo 'exec > > (tee ~/.command.out&) #cmd logging' >> /root/.zshrc
			echo 'output=$(cat ~/.command.out) #cmd logging' >> /root/.zshrc
			echo 'logger -p local1.notice -t zsh -i "$USER output: $output" #cmd logging' >> /root/.zshrc

		fi

		echo -e "\nFILE /home/kali/.zshrc\n"
		if grep 'cmd logging' /home/kali/.zshrc
		then
			echo "Already changed"
		else
			cp /root/.zshrc /root/.zshrc.back
			sed '/precmd.*/a\\tcommand="$(fc -n -e - -l -1)" #cmd logging\n\tlogger -p local1.notice -t zsh -i "$USER : $command" #cmd logging' /home/kali/.zshrc.back > /home/kali/.zshrc
			echo 'preexec() { #cmd logging' >> /home/kali/.zshrc
			echo 'exec > > (tee ~/.command.out&) #cmd logging' >> /home/kali/.zshrc
			echo 'output=$(cat ~/.command.out) #cmd logging' >> /home/kali/.zshrc
			echo 'logger -p local1.notice -t zsh -i "$USER output: $output" #cmd logging' >> /ome/kali/.zshrc

		fi

	elif [[ "$ANSWER" == 'no' ]]; then
		exit 0
	else 
		echo "incorrect answer"
	fi
elif [[ "$SHELL" == '/usr/bin/bash' ]]; then
	echo "you are using bash"
	echo "folowing files will be changed:"
	echo " - /etc/profile"
else 
	echo "Your shell: $SHELL is not defined or not supported "
fi

read -e -p "Create dedicated cmd log file in /var/log/cmd? (yes/no): " ANSWER
if [[ $ANSWER == 'yes' ]]; then
	if grep '#cmd logging' /etc/rsyslog.conf
	then
		echo "Already changed"
	else
		cp /etc/rsyslog.conf /etc/rsyslog.conf.back
		echo "local1.* -/var/log/cmd #cmd logging" >> /etc/rsyslog.conf
		systemctl restart rsyslog.service
	fi
elif [[ $ANSWER == 'no' ]]; then
	exit 0
else
	echo "incorrect answer"
fi

