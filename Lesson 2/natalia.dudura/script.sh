#!/bin/bash
#1
if
        dpkg --list | grep nginx
#1.1
then
        v=$(nginx -v 2>&1)
        apt purge nginx --yes;
        echo $v "nginx uninstalled"
#1.2
else
        echo "nginx is not installed"
fi
#2
echo "nginx installation process begins"

sudo apt install curl gnupg2 ca-certificates lsb-release --yes
echo "deb http://nginx.org/packages/ubuntu bionic nginx"  | tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

sudo apt-key fingerprint ABF5BD827BD9BF62
sudo apt update
sudo apt install nginx=1.14.2* --yes
#2.1
cd /etc/nginx

mkdir sites-available
mkdir sites-enabled

sed '/http {/a include /etc/nginx/sites-enabled' /etc/nginx/nginx.conf
#2.2
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
sudo service nginx restart
#2.3
curl 'http://127.0.0.1' | grep "Welcome to nginx!"
#3
LRED='\033[1;31m'
echo -n
awk '{print "Nginx main process have a PID:"; print $0}' /var/run/nginx.pid
echo  -en "Nginx count of 'worker' processes: $LRED $(ps -aux | grep nginx | grep -c worker)$LRED "