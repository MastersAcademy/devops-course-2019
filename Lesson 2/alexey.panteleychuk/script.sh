#!/bin/bash

set -x
id=$(id -u);
if [ "$id" -ne "0" ]
then echo "Run this file by sudo";
exit 0;
fi

name="nginx";
dpkg -l $name | grep -w install ;

if [ "$?" -ne "0" ]
then echo $name "doesn't install in your system" &&
apt update && apt install curl gnupg2 ca-certificates lsb-release && apt install -y $name"=1.14.2-1~bionic"
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \ | tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add - && apt-key fingerprint ABF5BD827BD9BF62 && apt update && apt install -y $name;
exit 1;
fi
cp /etc/nginx/nginx.conf /etc/nginx/sample_nginx.conf
line=`cat /etc/nginx/nginx.conf | awk '/./{line=$0} END{print NR}'`;
mv /etc/nginx/nginx.conf default.conf
sed "$num i\ include /etc/nginx/sites-enabled/\*.conf;" default.conf > nginx.conf
mkdir /etc/nginx/sites-available/ /etc/nginx/sites-enabled/;
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/;
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/;
service nginx restart;
curl -X GET 127.0.0.1 | grep -o "Welcome to nginx!" | head -1;

if [ "$?" -ne "1" ]
then nv=nginx -v;
echo $name$nv "Will be remove!!!" && apt remove -y $name;
exit 2;
fi

exit 0;

