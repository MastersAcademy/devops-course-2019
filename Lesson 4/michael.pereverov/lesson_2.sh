#!/bin/bash

#1. Вывести список установленных программ и проверить, если в этом списке nginx.
#  1.1. Если он есть. Удалить и вывести текст об удалении. Также указать, какая версия была удалена. 
#  1.2. Если его нет, вывести текст что он не установлен в системе.
RED='\033[1;31m'
YLW='\033[1;33m'
GRN='\033[0;32m'
NC='\033[0m'

APP_VERSION=1.14.2
APP_NAME=nginx

#Debian-like OS

status=$(dpkg -s $APP_NAME 2>/dev/null | grep --color=auto -o 'installed')
version=$(dpkg -s $APP_NAME 2>/dev/null | grep Version)
if [[ "$status" == 'installed' ]]
  then
    echo -e "\n${RED}$APP_NAME${NC} is already Installed"
    echo -e "$version\n"
      sleep 1
    echo -e "${YLW}Deletting...${NC}"
      sleep 2
    apt-get purge -y -q $APP_NAME
    echo -e "${GRN}Done!${NC}\n"
      sleep 2
  else
    echo -e "\n${RED}$APP_NAME${NC} is Not installed"
#    echo -e "${YLW}Installing...${NC}\n"
#    sleep 3
fi


#2. Добавить внешнее репо nginx: (документация на репо. http://nginx.org/en/linux_packages.html#Ubuntu) и установить nginx 1.14.2.

echo -e "\n${YLW}Install prerequisites...${NC}"
  sleep 1
apt-get update -qq && apt-get install -q\
    gnupg2 \
    ca-certificates \
    lsb-core \
    curl

echo -e "${YLW}\nAdding repo...${NC}"
  sleep 1
echo "deb [ arch=amd64 ] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx"  \
    | tee /etc/apt/sources.list.d/nginx.list

echo -e "\n${YLW}Adding repo keys...${NC}"
  sleep 1
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

echo -e "\n${YLW}Installing...${NC}"
  sleep 2

apt-get update -qq

#export DEBIAN_FRONTEND=noninteractive
yes | apt-get install -qq $APP_NAME=${APP_VERSION}*
echo -e "${GRN}Done!\n${NC}"
  sleep 1

#  2.1. Добавить папки sites-available и sites-enabled в корень конфигурационной папки nginx. Добавить папку sites-enabled в nginx.conf. 

echo -e "\n${YLW}\nMaking site config dir...${NC}"
  sleep 1
mkdir -p /etc/nginx/{sites-available,sites-enabled}
echo -e "\n${YLW}Adding sites-enabled to the nginx.conf...${NC}"
  sleep 1
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bac || true
sed '/http {/a #Added by a script \ninclude /etc/nginx/sites-enabled/*.conf;' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp
mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf || true

#  2.2. Перенести файл default.conf в папку sites-available  и сделать симлинк этого файла в папку sites-enabled.
echo -e "\n${YLW}Moving default.conf...${NC}"
  sleep 1
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/ || true
echo -e "\n${YLW}Enabling site...${NC}"
  sleep 1
ln -f -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf 

#    После чего перезапустить nginx.
nginx -t
echo -e "\n${YLW}Restarting ${RED}$APP_NAME${NC}...${NC}"
  sleep 1
service nginx restart
service nginx status 

#  2.3. Сделать запрос к nginx и получить в результате выполнения скрипта: “Welcome to nginx!”
echo -e "\n${YLW}Getting start page...${NC}"
  sleep 1
curl localhost:80

#3. Узнать и вывести PID nginx master process. Сделать это с помощью awk. 
#   Результат форматировать:  “Nginx main process have a PID: {число} “
echo -e "\nNginx main process has a PID: ${RED}$(ps aux | grep -i nginx | grep master | awk {'print $2'})${NC}"

#  3.1. Так же вывести количество запущенных nginx worker process. 
echo -e "\nNginx has ${RED}$(ps aux | grep -i nginx | grep worker | wc -l)${NC} worker process(es)"


