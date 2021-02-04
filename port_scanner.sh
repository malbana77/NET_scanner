#!/bin/bash
	mkdir port_scan 2>/dev/null
	cd port_scan
	echo ' _  ____    ____  ____  ____  _     
/ \/  __\  / ___\/   _\/  _ \/ \  /|
| ||  \/|  |    \|  /  | / \|| |\ ||
| ||  __/  \___ ||  \_ | |-||| | \||
\_/\_/     \____/\____/\_/ \|\_/  \|'
	yn=$(ip a | grep inet | grep -v inet6 | grep -v 127 | cut -d " " -f 6)
	NET=$yn
	ipp=$(echo $yn | cut -d "." -f 1)
	echo 'scanning hosts...'
	echo -e '\e[31m[Available Hosts]\e[0m'
	python3 ../Hosts_discover.py -t $NET -o
	for i in {243..248} {248..243} ; do echo -en "\e[38;5;${i}m######\e[0m" ; done ; echo
	echo ' ____  ____  ____  _____    ____  ____  ____  _     
/  __\/  _ \/  __\/__ __\  / ___\/   _\/  _ \/ \  /|
|  \/|| / \||  \/|  / \    |    \|  /  | / \|| |\ ||
|  __/| \_/||    /  | |    \___ ||  \_ | |-||| | \||
\_/   \____/\_/\_\  \_/    \____/\____/\_/ \|\_/  \|'
	echo 'scanning ports for::'

	###################FUNCTION##########################
ana () {
	if [[ -s $1 ]]
	then
		file=$1
		while read line ; do
			op=$(echo "$line"|grep "open" )
			os=$(echo "$line"|grep "OS" |cut -d ":" -f 2)
			er=$(echo "$line")
	
			if [ ! -z "$os" ]
			then
				echo -e "\e[38;5;246mOperating System : $os\e[0m"
				echo "operating system  : $os" >>report_$1
			fi		
			if [[ $op == *"open"*  ]]
			then
				ss=$(echo "$line"|grep "open"|cut -d " " -f 5)
				num=$(echo "$op"|cut -d ' ' -f 2)
				echo -e "Port \e[38;5;228m$num\e[0m is open \e[38;5;228m$ss\e[0m"
				echo -e "$num" >>report_$1
			fi
			if [[ $er == *"error"*  ]]
			then
				echo -e "All port is \e[38;5;228mclosed\e[0m or ip in \e[38;5;228mfirewall\e[0m"
			fi
		done < ${file}
		rm $1 2>/dev/null
	else
		
		rm $1 2>/dev/null
	fi
}

PS3="Enter your choose :# " export PS3
select loop in 'all network' 'specific ip'
do
if [ "$loop" == 'all network' ]
then
	file=hosts.txt
	rm report* $ipp* 2>/dev/null
	while read line ; do
		ip=$(echo "$line" )
			echo "The ip address : $line"
			python3 ../port_scanner.py -t $ip > Oport_$ip

			
			ana Oport_$ip
			echo ""
	done < ${file}
	exit
	
	
	
elif [ "$loop" == 'specific ip' ]
then
	echo 'Enter ip'
	read sip
	file=hosts.txt
	rm $sip 2>/dev/null
	while read line ; do
		if [ $sip == $line ]
		then
			echo "The ip address : $sip"
			python3 ../port_scanner.py -t $sip > Oport_$sip 
			ana Oport_$sip
		fi
	done < ${file}
	exit
fi
done
exit
