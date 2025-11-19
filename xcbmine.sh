#!/bin/bash

units_available()
{
	if punits=$(nproc) ; then
		echo $punits
	else
		echo ""
	fi
}

add_pool()
{
	if [[ "$1" -gt "1" ]]; then
		echo
		echo "$(tput setaf 3)●$(tput sgr 0) Please, select the additional mining pool."
		PS3="➤ Additional Pool: "
	else
		echo "$(tput setaf 3)●$(tput sgr 0) Please, select the mining pool."
		PS3="$(tput setaf 3)➤$(tput sgr 0) Pool: "
	fi

	units=`units_available`
	options=("CTR EU" "CTR EU Backup" "CTR AS" "CTR AS Backup" "CTR US" "CTR US Backup" "Other" "Exit")
	select opt in "${options[@]}"
	do
		case "$REPLY" in
			1)
				pool_heading $opt
				server[$1]="eu.catchthatrabbit.com"
				port[$1]=8008
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter wallet address: " wallet
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: " worker
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			2)
			pool_heading $opt
			server[$1]="eu1.catchthatrabbit.com"
				port[$1]=8008
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter wallet address: " wallet
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: " worker
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			3)
			pool_heading $opt
			server[$1]="as.catchthatrabbit.com"
				port[$1]=8008
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter wallet address: " wallet
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: " worker
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			4)
			pool_heading $opt
			server[$1]="as1.catchthatrabbit.com"
				port[$1]=8008
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter wallet address: " wallet
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: " worker
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			5)
			pool_heading $opt
			server[$1]="us.catchthatrabbit.com"
				port[$1]=8008
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter wallet address: " wallet
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: " worker
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			6)
			pool_heading $opt
			server[$1]="us1.catchthatrabbit.com"
				port[$1]=8008
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter wallet address: " wallet
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: " worker
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			7)
			pool_heading $opt
			server[$1]="sg.luckpool.io"
				port[$1]=3118
				if [[ "$1" -lt "2" ]]; then
					read -p "$(tput setaf 0)➤$(tput sgr 0) Enter wallet address: "cb60097d0f5145361d10005bb0c2e2c7fc371e5af82b
					read -p "$(tput setaf 3)➤$(tput sgr 0) Enter worker name: "cm_Tminer
					printf "$(tput setaf 3)●$(tput sgr 0) Available processing units: %s\n" $units
					read -p "$(tput setaf 3)➤$(tput sgr 0) How many units to use? [Enter for all] " threads
				fi
				break
				;;
			8) clear; exit 0;;
			*) echo "$(tput setaf 1)●$(tput sgr 0) Invalid option."; continue;;
		esac
	done
}

pool_heading()
{
	echo
	echo "╒════════════════════════════════════"
	echo "│ Pool $1"
	echo "╘════════════════════════════════════"
}

start_mining()
{

	SECURE_JIT=""
	cOS=$(uname -a | awk '{print $(1)}')
	cPLT=$(uname -m)
	if [ "$cOS" == "Darwin" ] && [ "$cPLT" == "arm64" ]; then
		SECURE_JIT="--jit-secure"
	fi

	LARGE_PAGES=""
	if [ -f /proc/sys/vm/nr_hugepages ]; then
		if [ $(cat /proc/sys/vm/nr_hugepages) -gt 0 ]; then
			LARGE_PAGES="--large-pages"
		fi
	fi

	HARD_AES=""
	if [ $(grep aes /proc/cpuinfo 2>&1 | wc -c) -ne 0 ];	then
		HARD_AES="--hard-aes"
	fi

	POOLS=""
	for pool in "${@:2}"
	do
		POOLS+="-P ${pool} "
	done

	THREAD=""
	if [[ "$1" -gt "0" ]]; then
		THREAD="-t ${1}"
	fi

	if [ ! -f "coreminer" ]; then
		echo "$(tput setaf 1)●$(tput sgr 0) Miner not found!"
		exit 2
	fi

	if [[ -x "coreminer" ]]; then
		./coreminer --noeval $LARGE_PAGES $HARD_AES $SECURE_JIT $POOLS $THREAD
	else
		chmod +x coreminer
		./coreminer --noeval $LARGE_PAGES $HARD_AES $SECURE_JIT $POOLS $THREAD
	fi
}

compose_stratum()
{
	# scheme://wallet[.workername][:password]@hostname:port[/...]
	if [[ -z "$4" ]]; then
		echo "stratum1+tcp://$1@$2:$3"
	else
		echo "stratum1+tcp://$1.$4@$2:$3"
	fi
}

export_config()
{
	> $1
	for setting in "${@:2}"
	do
		echo $setting >> $1
	done
}

import_config()
{
	. $1
}

autostart_service()
{
	if [ -f "/etc/systemd/system/coreminer.service" ]; then
		echo "$(tput setaf 2)●$(tput sgr 0) Autostart service already exists."
		return
	fi
	echo "$(tput setaf 2)●$(tput sgr 0) Creating autostart service."
	> /etc/systemd/system/coreminer.service
	echo "[Unit]" >> /etc/systemd/system/coreminer.service
	echo "Description=CoreVerificator" >> /etc/systemd/system/coreminer.service
	echo "After=network.target" >> /etc/systemd/system/coreminer.service
	echo "StartLimitIntervalSec=0" >> /etc/systemd/system/coreminer.service
	echo "" >> /etc/systemd/system/coreminer.service
	echo "[Service]" >> /etc/systemd/system/coreminer.service
	echo "Type=simple" >> /etc/systemd/system/coreminer.service
	echo "WorkingDirectory=$(pwd)" >> /etc/systemd/system/coreminer.service
	echo "ExecStart=/bin/bash $(pwd)/mine.sh" >> /etc/systemd/system/coreminer.service
	echo "Restart=always" >> /etc/systemd/system/coreminer.service
	echo "RestartSec=3" >> /etc/systemd/system/coreminer.service
	echo "TimeoutStartSec=0" >> /etc/systemd/system/coreminer.service
	echo "" >> /etc/systemd/system/coreminer.service
	echo "[Install]" >> /etc/systemd/system/coreminer.service
	echo "WantedBy=multi-user.target" >> /etc/systemd/system/coreminer.service
	systemctl daemon-reload
	systemctl enable coreminer.service
	echo "$(tput setaf 2)●$(tput sgr 0) Autostart service created."
	echo "$(tput setaf 2)●$(tput sgr 0) Vacuuming journal."
	journalctl --rotate && journalctl --vacuum-time=1d
	echo "$(tput setaf 2)●$(tput sgr 0) Starting autostart service and script."
	systemctl start coreminer.service
}

extdrive_check()
{
	EXTCONF=$(lsblk -nlo mountpoint | awk '$0 ~ /^\/media\/[^/]+\/coredrive/ {print}')
	if [ -z "$EXTCONF" ]; then
		echo "pool.cfg"
	else
		echo "${EXTCONF}/pool.cfg"
	fi
}

while :
do

clear
echo " ▄▀▀ ▄▀▄ █▀▄ ██▀   ██▄ ▄▀▀ █▄█ █▄ █"
echo " ▀▄▄ ▀▄▀ █▀▄ █▄▄   █▄█ ▀▄▄ █ █ █ ▀█"
echo

CONFIG=`extdrive_check`
if [ -f "$CONFIG" ]; then
	echo "$(tput setaf 2)●$(tput sgr 0) Mine settings file '$CONFIG' exists."
	echo "$(tput setaf 2)●$(tput sgr 0) Importing settings."
	import_config $CONFIG
	if [ "$update" = true ]; then
		update_app
	fi
	ICANWALLET=${wallet//[[:blank:]]/}
	validate_wallet $ICANWALLET
	echo "$(tput setaf 2)●$(tput sgr 0) Wallet validated."
	STRATUM=""
	echo "$(tput setaf 2)●$(tput sgr 0) Configuring stratum server."
	for i in "${!server[@]}"
	do
		STRATUM+=`compose_stratum "$ICANWALLET" "${server[$i]}" "${port[$i]}" "$worker"`
		STRATUM+=" "
	done
	echo "$(tput setaf 2)●$(tput sgr 0) Starting mining command."
	start_mining "$threads" $STRATUM
else
	echo "$(tput setaf 3)●$(tput sgr 0) Mine settings file '$CONFIG' doesn't exist."
	echo "$(tput setaf 2)●$(tput sgr 0) Proceeding with setup."
	echo
	while true
	do
		read -r -p "$(tput setaf 3)➤$(tput sgr 0) Check for the update? [yes/no] " upd
		case $upd in
			[yY][eE][sS]|[yY])
				update_app
				break
					;;
			[nN][oO]|[nN])
				echo "$(tput setaf 2)●$(tput sgr 0) Update skipped."
				break
					;;
			*)
				echo "$(tput setaf 1)➤$(tput sgr 0) Invalid input. [yes,no]"
					;;
		esac
	done
	LOOP=1
	add_pool $LOOP
	ICANWALLET=${wallet//[[:blank:]]/}
	validate_wallet $ICANWALLET
	echo "$(tput setaf 2)●$(tput sgr 0) Wallet validated."

	echo
	(( LOOP++ ))
	while true
	do
		read -r -p "$(tput setaf 3)➤$(tput sgr 0) Do you wish to add additional pool? [yes/no] " back
		case $back in
			[yY][eE][sS]|[yY])
				add_pool $LOOP
				(( LOOP++ ))
					;;
			[nN][oO]|[nN])
				break
					;;
			*)
				echo "$(tput setaf 1)➤$(tput sgr 0) Invalid input. [yes,no]"
					;;
		esac
	done

	echo
	echo "$(tput setaf 2)●$(tput sgr 0) Saving the settings."

	EXPORTDATA=""
	if [[ "$threads" -gt "0" ]]; then
		EXPORTDATA+="$CONFIG wallet=${ICANWALLET} worker=${worker} threads=${threads}"
	else
		EXPORTDATA+="$CONFIG wallet=${ICANWALLET} worker=${worker}"
	fi
	for ((i = 1; i < $LOOP; i++)); do
		EXPORTDATA+=" server[$i]=${server[$i]} port[$i]=${port[$i]}"
	done
	export_config $EXPORTDATA

	echo
	while true
	do
		read -r -p "$(tput setaf 3)➤$(tput sgr 0) Add the autostart service? [yes/no] " autostart
		case $autostart in
			[yY][eE][sS]|[yY])
				autostart_service
				exit 0
				break
					;;
			[nN][oO]|[nN])
				break
					;;
			*)
				echo "$(tput setaf 1)➤$(tput sgr 0) Invalid input. [yes,no]"
					;;
		esac
	done

	echo
	while true
	do
		read -r -p "$(tput setaf 3)➤$(tput sgr 0) Start mining now? [yes/no] " mine
		case $mine in
			[yY][eE][sS]|[yY])
				STRATUM=""
				for ((i = 1; i < $LOOP; i++)); do
					STRATUM+=`compose_stratum "$ICANWALLET" "${server[$i]}" "${port[$i]}" "$worker"`
					STRATUM+=" "
				done
				start_mining "$threads" $STRATUM
				break
					;;
			[nN][oO]|[nN])
				exit 0
					;;
			*)
				echo "$(tput setaf 1)➤$(tput sgr 0) Invalid input. [yes,no]"
					;;
		esac
	done
fi
sleep 60
done
