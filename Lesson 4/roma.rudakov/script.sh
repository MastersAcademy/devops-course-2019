\#!/bin/bash
if [[ $(id -u) -ne 0 ]]
  then
    echo "Please run as root";
    exit 0;
fi
dpkg --get-selections | grep -q nginx;
if [ $? != 0 ]
then
	echo "nginx is not installed";
else 
	echo "nginx version";
	nginx -v;
	apt remove -y nginx;
fi 

	apt-get install --assume-yes curl gnupg2 ca-certificates lsb-release;
	echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list;
	curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -;
	apt-get update
	apt-get install -y nginx=1.14.2-1~xenial
	echo 'nginx -v'

	mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled;
	cp /etc/nginx/nginx.conf /etc/nginx/backup_nginx.conf;
	sed -i '$ d' /etc/nginx/nginx.conf && echo -e "    include /etc/nginx/sites-enabled/\*.conf;\n}">> /etc/nginx/nginx.conf;
	cp /etc/nginx/conf.d/default.conf  /etc/nginx/conf.d/backup_default.conf;
	mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/;
	ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/;

	service nginx start;
	
	curl 'http://127.0.0.1' -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)';
	ngX_master_PID=`ps aux | grep "[n]ginx: master" | awk '{print $2}'`;
	ngX_numb_of_proc=`ps aux | grep "[n]ginx: worker" | grep -c "[0-9]"`;

if [ $ngX_numb_of_proc != 0 ]
then
	echo "Nginx master process PID: $ngX_master_PID";
	echo -e "Nginx worker process count: \033[0;31m $ngX_numb_of_proc \033[0m ";
else
	echo "service nginx stopped";
fi

exit 0;
