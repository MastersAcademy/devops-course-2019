#!/bin/bash
set -x
	
	sudo su

#  1. Вывести список установленных программ и проверить, если в этом списке nginx. 
	nginx_setup=$(dpkg -l nginx)
	nginx_version=$(nginx -v)
#  1.1. Если он есть. Удалить и вывести текст об удалении. Также указать, какая версия была удалена. 
#  1.2. Если его нет, вывести текст что он не установлен в системе.
if [ "$nginx_setup" != "0" ]
then
	echo "Check version nginx"
	echo "$nginx_version"
	apt remove -y nginx
	echo "$nginx_version is remooved"
else
	#2. Добавить внешнее репо nginx: (документация на репо. http://nginx.org/en/linux_packages.html#Ubuntu) и установить nginx 1.14.2.
	echo "connect repo"
	echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
	echo "to import key"
	curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
	echo "Install nginx"
	apt update && apt install -y nginx
	service nginx start
fi
	echo "nginx installed"

#  2.1. Добавить папки sites-available и sites-enabled в корень конфигурационной папки nginx. Добавить папку sites-enabled в nginx.conf. 
	mkdir /etc/nginx/sites-available
	mkdir /etc/nginx/sites-enabled
	echo "folders sites-available and sites-enabled is added"
	echo "-------------------------------------------------"
	echo "add folder sites-enabled in nginx.conf."
	echo "include /etc/nginx/sites-enabled/*;" >> /etc/nginx/nginx.conf

#  2.2. Перенести файл default.conf в папку sites-available  и сделать симлинк этого файла в папку sites-enabled.

	mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/
	ln -s /etc/nginx/sites-enabled/default.conf /etc/nginx/nginx.conf
 
#    После чего перезапустить nginx. 

	service nginx restart

# 2.3. Сделать запрос к nginx и получить в результате выполнения скрипта: “Welcome to nginx!”

	request_to_nginx=`echo wget localhost:80 -O -`
	echo "$request_to_nginx"

#3. Узнать и вывести PID nginx master process. Сделать это с помощью awk.

#pid_nginx=$(pgrep nginx)
	pid_nginx=$(ps | grep nginx | awk '{print $1}')
#pid_nginx=top | awk nginx
 
#   Результат форматировать:  “Nginx main process have a PID: {число} “
	echo "Nginx main process have a PID: $pid_nginx"
#  3.1. Так же вывести количество запущенных nginx worker process. 
#    Форматировать так же как в задании 3, но число процессов должны быть красным.
	RED=$(\033[0;31m) #set red color
	NC='\033[0m'	#set no color
	process_count=$(ps | grep nginx | wc | awk '{print $2}')
	echo "Nginx worker process: ${RED}$process_count${NC}"
	