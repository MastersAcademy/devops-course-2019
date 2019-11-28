#!/bin/bash
if [ "$EUID" -ne 0 ]
   then echo "Please run as root"
fi

# Task  1
num=$(apt list --installed | grep -c nginx)
if [[ "$num" -eq 0 ]]
then
   echo "Nginx isn't install"
else
   apt show nginx | sed '2!d'
   apt purge -y nginx
   echo "Nginx removed"
fi

# Task  2
apt update
apt install -y curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt update
apt install nginx=1.14.2-1~xenial
cd /etc/nginx
mkdir sites-available sites-enabled
cd conf.d
mv default.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled
echo "include /etc/nginx/sites-enabled/*.conf;" > /etc/nginx/conf.d/include.conf
service nginx restart
curl -X GET 127.0.0.1 | grep -o "Welcome to nginx!" | head -1;

# Task  3
pid_master=$(ps aux | grep nginx | awk '{print $2}' | sed '1!d')
pid_all=$(($(ps aux | grep -c nginx)-2))
if [[ $pid_all -eq 0 ]]
then
   echo "Nginx doesn't work"
else
   echo "Nginx main process have a PID: $pid_master"
   echo -e "Nginx worker process: \033[31m $pid_all \033[m"
fi
