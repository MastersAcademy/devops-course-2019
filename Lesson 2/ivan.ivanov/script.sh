#!/bin/bash
echo "Installed soft"
dpkg -l | cut -d " " -f 3
dpkg -l | cut -d " " -f 3 | grep nginx 
is_installed=$?

cur_ver=`nginx -v 2>&1 | grep nginx | sed -e 's/^.*\///' | sed -e 's/\ .*$//'`

if [ "$is_installed" == "0" ] 
	then
	apt-get -y purge nginx* > /dev/null
	echo "Nginx version $cur_ver Deleted"
	cur_ver=""
fi
	
if ([ "$cur_ver" == "" ] || [ "$is_installed" == "1" ]) 
	then
	apt-get update -y
	apt-get install -y curl gnupg2 ca-certificates lsb-release
	echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list
	curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
	apt-key fingerprint ABF5BD827BD9BF62
	apt-get -y update
	apt-get -y install nginx=1.14.2-1~bionic
	mkdir -p /etc/nginx/sites-available
	mkdir -p /etc/nginx/sites-enabled
	mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available
	ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled
	echo "include /etc/nginx/sites-enabled/*.conf;" > /etc/nginx/conf.d/include.conf
	nginx -t && service nginx restart
	curl 127.0.0.1 2>&1 | grep title | sed -e 's/^.*>W/W/' | sed -e 's/<.*$//'
fi
