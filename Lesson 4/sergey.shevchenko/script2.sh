#!/bin/bash

apt-get update
apt install -y curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
apt-key fingerprint ABF5BD827BD9BF62
apt update
apt install -y nginx

cd /etc/nginx &&  mkdir sites-available/ sites-enabled/ 

str=`cat /etc/nginx/nginx.conf | awk '/./{line=$0} END{print NR}'`
cd /etc/nginx/ && mv nginx.conf bak.conf && sed "$str i\    include /etc/nginx/sites-enabled/\*.conf;" bak.conf > nginx.conf

mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

service nginx restart

curl  -L http://localhost/ |grep -o "Welcome to nginx!"
