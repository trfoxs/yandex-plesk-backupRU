#!/bin/bash
##
# Name: Еженедельное обновление Plesk Яндекс
# Author: trfoxs
# Update: trfoxs
# Version: 1.0.1
# Description: яндекс-диск плеск

if [ $(which yandex-disk) ]; then
clear
echo -e "
.########.########..########..#######..##.....##..######.
....##....##.....##.##.......##.....##..##...##..##....##
....##....##.....##.##.......##.....##...##.##...##......
....##....########..######...##.....##....###.....######.
....##....##...##...##.......##.....##...##.##.........##
....##....##....##..##.......##.....##..##...##..##....##
....##....##.....##.##........#######..##.....##..######.

[TR] Yandex Disk Plesk Yedekleme
[RU] Резервное копирование Plesk на Яндекс Диске

................................................
"
	echo -e "[\e[31mOK\e[39m] Обнаружен Яндекс-диск !"
	echo -e "[\e[93mDOING\e[39m] Укажите домашнюю директорию Яндекса, например: /var/home/plesk-backup: "
	read -p "Имя каталога: " foldername
	
	# folder check
	if [ -d "$foldername" ]; then 
		echo -e "[\e[31mOK\e[39m] $foldername уже существует"
	
		# create plesk cron.weekly
		if [ $(which plesk) ]; then 
			echo -e "[\e[31mOK\e[39m] Plesk обнаружен"
			echo -e "[\e[93mDOING\e[39m] Создание Plesk cron.weekly..."
			rm -f /etc/cron.weekly/plesk-yandex-backup
			touch /etc/cron.weekly/plesk-yandex-backup

echo "\
#!/bin/bash
##
# Name: Еженедельное обновление Plesk Яндекс
# Author: trfoxs
# Update: trfoxs
# Version: 1.0.1
# Description: яндекс-диск плеск

SYNC_DIR=$foldername/plesk-backup
DATE="'`date +%d-%m-%Y-%H%i%s`'"

if [ "'$(which yandex-disk)'" ]; then 
[ -d "'$SYNC_DIR'" ] || mkdir "'$SYNC_DIR'"
/usr/local/psa/bin/pleskbackup server --incremental --description=\"Инкрементальное резервное копирование сервера\" --output-file=\""'$SYNC_DIR'"/server-incremental-backup-"'$DATE'".tar\"
yandex-disk sync
exit 0
else
exit 1
fi"\ > /etc/cron.weekly/plesk-yandex-backup

			chmod +x /etc/cron.weekly/plesk-yandex-backup
			
			sleep 5
			echo -e "[\e[31mOK\e[39m] Plesk cron.weekly создан успешно."
			echo -e "\n наслаждайся этим :) "
			
		else 
			echo -e "[\e[31mFAIL\e[39m] Plesk не установлен, попробуйте еще раз."
			echo -e "[\e[31mOK\e[39m] Программа закрывается :(."
			exit 1
		fi
		
	else
		echo -e "[\e[31mFAIL\e[39m] Убедитесь, что каталог существует, и повторите попытку.."
		echo -e "[\e[31mOK\e[39m] Программа закрывается :(."
		exit 1
	fi
fi