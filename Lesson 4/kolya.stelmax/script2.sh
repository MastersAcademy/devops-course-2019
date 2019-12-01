#!/bin/bash

if [[ "$EUID" -ne 0 ]];
 then
  echo "Please run script as root"
  exit 1;
fi

if

 dpkg --list | grep nginx;

then
nginx -v;
else
echo "nginx is not installed";
apt-get -y remove nginx;

fi

#task2
apt-get -y  update
apt-get install -y curl gnupg2 ca-certificates lsb-release;
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" |  tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt-key fingerprint ABF5BD827BD9BF62 #key authenticity
apt-get -y update
apt-get install -y  nginx=1.14.2-1~xenial

echo `nginx -v`;

mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled
sed -i '/http {/a include /etc/nginx/sites-enabled/*.conf;' /etc/nginx/nginx.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/default.conf
ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
service nginx restart
curl -X GET 127.0.0.1 | grep -o "Welcome to nginx!" | head -1

nginx_proc=$(ps -lfC nginx | grep "master process" | awk '{print $4}')
nginx_proc_count=$(ps -lfC nginx | grep -c "worker process")
echo "Nginx main process have a PID: $nginx_proc"
echo -e "Number of Nginx working processes: \033[31m$nginx_proc_count\e[0m"
