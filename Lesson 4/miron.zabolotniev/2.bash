# !/bin/bash

# 1

apt-get update  
apt-get install sudo 
apt-get install lsb-core --yes
apt-get install curl

pkg="nginx"
isInstalled=$(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed") 
if [ $isInstalled -eq 1 ]
then 
    v=$(dpkg-query -W -f='${Version}' $pkg)
    sudo apt-get remove $pkg
    echo Delete version => $v
else 
    echo No packages found.
fi

# 2

sudo apt install curl gnupg2 ca-certificates lsb-release -- yes
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt update
sudo apt install nginx=1.14.2*

sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
# sudo echo "/etc/nginx/sites-enabled" >> sudo /etc/nginx/nginx.conf
sudo sh -c "echo 'include /etc/nginx/sites-enabled/*.conf;' >> /etc/nginx/conf.d/dep.conf"

sudo mv /etc/nginx/conf.d/default.conf  /etc/nginx/sites-available/default.conf
sudo ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
service nginx restart
curl -X GET 127.0.0.1 | grep -o "Welcome to nginx"

#3 

ps aux | awk '/nginx master/ {print "Nginx main process have a PID:", $2}'
echo "Nginx worker process count: $(tput setaf 1)$(ps aux | awk '/nginx worker/' | wc -l)$(tput sgr0)"


