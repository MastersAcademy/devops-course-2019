#!/bin/bash
#check if running as root
id=$(id -u)
if [ "$id" -ne "0" ]

then
	echo "Please run as root" 
	exit 0

fi
# Task 1
if 
	dpkg --list | grep nginx #check if nginx installed
# Task 1.1
then 
	v=$(nginx -v 2>&1)
	apt purge nginx --yes; #completely remove nginx
	echo $v "was removed successfully"
#Task 1.2
else
 	echo "no nginx installed" 
fi
#Task 2
echo "Installing nginx"
sudo apt install curl gnupg2 ca-certificates lsb-release --yes
echo "deb [arch=amd64] http://nginx.org/packages/ubuntu bionic nginx" \
   		| sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
apt-key fingerprint ABF5BD827BD9BF62
apt update
apt install nginx=1.14.2* --yes
#Task 2.1
cd /etc/nginx
mkdir sites-available
mkdir sites-enabled
sed '/http {/a include /etc/nginx/sites-enabled' /etc/nginx/nginx.conf
#Task 2.2
cp /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
service nginx restart
#Task 2.3
curl 127.0.0.1 |  grep -om 1 "Welcome to nginx"
#Task 3
LRED='\033[1;31m'
echo -n
awk '{print "Nginx main process have a PID:"; print $0}' /var/run/nginx.pid #NGINX main process PID
echo -en "Nginx number of 'worker' processes: $LRED $(ps -aux | grep nginx | grep -c worker)" #Number s in bold red color

