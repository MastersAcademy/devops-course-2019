#!/bin/bash
# set -x #отладка
# Задание 1
echo "Шо мы тут имеем"
dpkg -l #выводим установленные пакеты
echo "Ага..."
dpkg -s nginx # ищем nginx
if dpkg -l | grep ii | grep nginx
then
ver=$(nginx -v 2>&1)
apt purge nginx -y
echo "$ver удалено"
else
echo "Нема нічого (nginx)"
fi

# Задание 2

apt update
apt install -y curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt update
apt -y install nginx=1.14.2-1~bionic
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled
echo "include /etc/nginx/sites-enabled/*.conf;" > /etc/nginx/conf.d/include.conf
nginx -t && service nginx restart
curl localhost | grep title

# Задание 3

psID=`ps -lfC nginx | grep "master" | awk '{print $4}'`;
pssa=`ps -lfC nginx | grep -c "^[0-9]"`;
pss=$(($pssa-1))
if [[ $pssa -ne 0 ]]
then
echo "Nginix main process have a PID: $psID";
echo -e "nginx worker process: \e[31m $pss \e[0m";
else
echo "Nginix dead";
fi
