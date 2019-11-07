#!/bin/bash
if [[ "$EUID" -ne 0 ]] # EUID 0 - root for the current process
then
	echo "Please run as root";
	exit 0;
fi

# Install Nginx
apt install curl gnupg2 ca-certificates lsb-release;
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list    
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt-key fingerprint ABF5BD827BD9BF62
apt install nginx
# Install Nginx. End.
echo -e "\033[31;1m";
echo `nginx -v`;
echo -e "\033[0m";

cd /etc/nginx/; 
mkdir sites-available/ sites-enabled/;
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/;

service nginx restart;

curl GET localhost:80 | grep -o "Welcome to nginx!" | head -1;

exit 0;
