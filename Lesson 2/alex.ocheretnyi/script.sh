#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
is_nginx=$(dpkg -l | grep nginx)

if [ -n "$is_nginx" ]
then
 nginx_v=$(nginx -v 2>&1)
 apt purge --auto-remove -y nginx nginx-core
 echo "$nginx_v"
 echo "Nginx has been deleted from your system."
else 
 echo "Nginx is not installed on your system."
fi

apt update
apt install curl gnupg2 ca-certificates lsb-release

echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signig.key | sudo apt-key add -

apt update
apt install nginx=1.14.2*

cd /etc/nginx && sudo mkdir sites-available sites-enabled

nginx_config=$(sudo sed '/include.*conf/a \    include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf)

cat /dev/null > /etc/nginx/nginx.conf
echo "$nginx_config" > /etc/nginx/nginx.conf

mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

service nginx restart
nginx_welcome=$(curl localhost | grep "Welcome to nginx!")

if [ -n "$nginx_welcome" ]
then
 echo "Welcome to nginx!"
fi

nginx_master_pid=$(ps aux | grep nginx | grep master | awk '{print $2}')
echo "Nginx main process have a PID:{$nginx_master_pid}"

nginx_worker_process=$(ps aux | grep nginx | grep "worker process" | awk 'BEGIN{print ARGC}')
echo -e  "Number of launched nginx worker processes: {${RED}$nginx_worker_process${NC}}"
