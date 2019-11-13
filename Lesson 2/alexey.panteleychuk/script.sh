#!/bin/bash

set -x
id=$(id -u);
#check if isn't sudo 
if [ "$id" -ne 0 ]
  then echo "Run this file by sudo";
  exit 0;
fi

name="nginx";

#check install nginx
dpkg -s $name | grep -w install 1>/dev/null;

#if true, install nginx and create conf files
if [ "$?" -ne 0 ]
 then echo $name "doesn't install in your system" && apt update && apt install curl gnupg2 ca-certificates lsb-release
	echo "deb [arch=amd64] http://nginx.org/packages/ubuntu bionic nginx"  | tee /etc/apt/sources.list.d/nginx.list
	curl -fsSL https://nginx.org/keys/nginx_signing.key |  apt-key add -;
	apt update && apt install nginx=1.14.2* --yes;
	cp /etc/nginx/nginx.conf /etc/nginx/sample_nginx.conf
	line=`cat /etc/nginx/nginx.conf | awk '/./{line=$0} END{print NR}'`;
	cd /etc/nginx/
	mv /etc/nginx/nginx.conf default.conf
	sed "$num i\ include /etc/nginx/sites-enabled/\*.conf;" default.conf > nginx.conf
	mkdir /etc/nginx/sites-available/ /etc/nginx/sites-enabled/;
	mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/;
	ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/;
	service nginx restart;
	curl -X GET 127.0.0.1 | grep -o "Welcome to nginx!" | head -1;
 else
#remove nginx
	nv=$(nginx -v);
	echo $name$nv "Will be remove!!!" && apt remove -y $name;
fi
#task 3
RED='\033[1;31m'
echo -n
awk '{print "Nginx main process have a PID:"; print $0}' /var/run/nginx.pid
echo  -en "Nginx number of 'worker' processes: $RED $(ps -aux | grep nginx | grep -c worker)$RED"

exit 0;
