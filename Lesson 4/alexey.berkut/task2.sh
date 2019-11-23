#!/bin/bash

#Task 1
if [[ "$EUID" -ne 0 ]] # root check
then
	echo "Please run as root";
	exit 0;
fi

apt list --installed | grep -q nginx;

if [[ $? != 0 ]]
then
	echo "Nginx web server is not install.";
else
	echo `nginx -v`;
	echo -e "\033[31;4mRemove\033[0m Nginx...";
	apt remove -y nginx*;
fi

# Task 2
# Install Nginx
apt update && apt install -y curl gnupg2 ca-certificates lsb-release;
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
	| tee /etc/apt/sources.list.d/nginx.list;    
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -;
apt-key fingerprint ABF5BD827BD9BF62;
apt update && apt install -y nginx=1.14.2-1~xenial;
nginx -v # Show version
# Install Nginx. End

num=`cat /etc/nginx/nginx.conf | awk '/./{line=$0} END{print NR}'`; # Get the last no-empty line number
cd /etc/nginx/ && mv nginx.conf defaultNginx.conf && sed "$num i\    include /etc/nginx/sites-enabled/\*.conf;" defaultNginx.conf > nginx.conf && mkdir sites-available/ sites-enabled/;
	# Create backup nginx.conf (defaultNginx.conf)
	# Create nginx.conf with included folder sites-enabled
	# Create folders sites-available & sites-enabled

mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/;
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/;

# systemctl restart nginx.service;
service nginx restart;

echo -e "\033[31;1m";
nginx -t # Test nginx
echo -e "\033[0m";

curl -X GET 127.0.0.1 | grep -o "Welcome to nginx!" | head -1;

# Task 3
processId=`ps -lfC nginx | grep "master" | awk '{print $4}'`;
processCount=`ps -lfC nginx | grep -c "^[0-9]"`;

if [[ $processCount -ne 0 ]]
then
	echo "Nginx main process have a PID: $processId";
	echo -e "Nginx worker process: \033[31;5m$processCount\033[0m";
else
	echo "Nginx is not running..";
fi

exit 0;
