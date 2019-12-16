#!/bin/bash

if [[ $(id -u) -ne 0 ]]; 
then
  echo "Please run script as root"
  exit 1
fi

set -x

#  1. Вывести список установленных программ и проверить, если в этом списке nginx. 
	nginx_setup=$(apt list --installed | grep nginx)
#  1.1. Если он есть. Удалить и вывести текст об удалении. Также указать, какая версия была удалена. 
#  1.2. Если его нет, вывести текст что он не установлен в системе.
if [ "$nginx_setup" != "" ];
then
	echo "Check version nginx"
	nginx_version=$(nginx -v)
	echo "$Nginx verion is $nginx_version"
	apt purge -y nginx*
	apt-get autoremove
	echo "$nginx_version is remooved"
	exit 1
else
	#2. Добавить внешнее репо nginx: (документация на репо. http://nginx.org/en/linux_packages.html#Ubuntu) и установить nginx 1.14.2.
	echo "connect repo"
	apt-get update && apt-get install -y curl gnupg2 ca-certificates lsb-release
	echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
	echo "to import key"
	curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
	apt-key fingerprint ABF5BD827BD9BF62
	echo "Install nginx"
	apt update && apt install -y nginx=1.14.2*
fi
	echo "nginx installed"

#  2.1. Добавить папки sites-available и sites-enabled в корень конфигурационной папки nginx. Добавить папку sites-enabled в nginx.conf. 
mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled
echo "folders sites-available and sites-enabled is added"
echo "-------------------------------------------------"
echo "add folder sites-enabled in nginx.conf."
cp /etc/nginx/nginx.conf /etc/nginx/beckup_nginx.conf
echo 'include /etc/nginx/sites-enabled/*.conf;' >> /etc/nginx/conf.d/dep.conf

#  2.2. Перенести файл default.conf в папку sites-available  и сделать симлинк этого файла в папку sites-enabled.
#	cp /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled
#    После чего перезапустить nginx.
nginx -t
service nginx restart

# 2.3. Сделать запрос к nginx и получить в результате выполнения скрипта: “Welcome to nginx!”

curl -X GET 127.0.0.1 | grep -o "Welcome to nginx!" | head -1

#3. Узнать и вывести PID nginx master process. Сделать это с помощью awk.

pid_nginx=$(ps -ax | grep nginx | awk '{print $1}')

#   Результат форматировать:  “Nginx main process have a PID: {число} “
echo "Nginx main process have a PID: $pid_nginx"
#  3.1. Так же вывести количество запущенных nginx worker process. 
#    Форматировать так же как в задании 3, но число процессов должны быть красным.

process_count=$(ps -lfC nginx | grep worker | wc -l)
echo -e "Nginx worker process: \e[31m$process_count\e[0m"
echo "SCRIPT THE END"
