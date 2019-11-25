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

cd /etc/nginx/;
mkdir sites-available/ sites-enabled/;
sed -i '/http {/a include /etc/nginx/sites-enabled/\*.conf;' /etc/nginx/nginx.conf
# -i for line breaks
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available
#if the file in conf.d you need to use this line of code
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/;

service nginx restart

curl 127.0.0.1 | grep c  "Welcome to nginx" | head -1;

#task 3
ps -lfC nginx | grep 'master' | awk '{print "Nginx main process have a PID:" $4}';
#formatting result: Nginx main process have a PID
ps -lfC nginx | grep 'worker' | awk '{print "Nginx worker process: \33[1;31m" $1}';
#formatting result: Nginx worker process

