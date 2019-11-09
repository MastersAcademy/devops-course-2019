#!/bin/bash
if

 dpkg --list | grep nginx;

then
nginx -v;
else
echo "nxing is not installed";
apt remove nginx;

fi

sudo apt install curl gnupg2 ca-certificates lsb-release;
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key |sudo apt-key add -
apt-key fingerprint ABF5BD827BD9BF62 #key authenticity
sudo apt update
sudo apt install -y  nginx=1.14.2*

echo `nginx -v`;

cd /etc/nginx/;
mkdir sites-available/ sites-enabled/;
mv etc/nginx/conf.d/default.conf etc/nginx/sites-available
#if the file in conf.d you need to use this line of code
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/;

service nginx restart

curl  localhost:80 | grep -o  "Welcome to nginx" | head -1;


