#!/bin/bash

if sudo dpkg -l | grep ii | grep nginx
then
  ver=$(nginx -v 2>&1)
  sudo apt purge nginx --yes
  echo "$ver successfully removed"
else
 echo "No nginx installed"
fi

sudo apt install curl gnupg2 ca-certificates lsb-release --yes
echo "deb [arch=amd64] http://nginx.org/packages/ubuntu bionic nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-key fingerprint ABF5BD827BD9BF62
sudo apt update --yes
sudo apt install nginx=1.14.2* --yes

sudo cp /etc/nginx/nginx.conf /etc/nginx/nginxbckp.conf
sudo mkdir /etc/nginx/sites-available/ /etc/nginx/sites-enabled/
sudo sed -i '/http {/a include /sites-enabled/\*.conf;' /etc/nginx/nginx.conf
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
sudo service nginx restart

pspid=$(ps -lfC nginx | grep master | awk '{print $4}');
#filepid=$(cat /var/run/nginx.pid);
echo -e "Nginx main process have a PID: \033[37;1;41m $pspid \033[0m";

cntpsw=$(ps -lfC nginx | grep worker | wc -l) 
echo -e "Count of worker process : \033[37;1;41m $cntpsw \033[0m";