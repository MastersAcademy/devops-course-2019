#!/bin/bash
if [[ $(id -u) -ne 0 ]]
  then
    echo "Please run as root";
    exit 0;
fi
dpkg --get-selections | grep -q nginx;
if [ $? != 0]
then
	echo "nginx is not installed";
else 
	echo "nginx version";
	nginx -v;
	apt remove -y nginx;
fi 
	sudo apt install curl gnupg2 ca-certificates lsb-release
	echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    		| sudo tee /etc/apt/sources.list.d/nginx.list
	curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
	sudo apt-key fingerprint ABF5BD827BD9BF62
	apt update
	apt install -y nginx
	echo 'nginx -v'
	
