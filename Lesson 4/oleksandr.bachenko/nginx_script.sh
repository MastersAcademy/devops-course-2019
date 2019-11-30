#!/bin/bash
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run script as root"
  exit 1	
fi

if dpkg -l | grep ii | grep nginx
then
  ver=$(nginx -v 2>&1)
  apt purge nginx --yes
  echo "$ver successfully removed"
else
 echo "No nginx installed"
fi

apt update

apt install curl gnupg2 ca-certificates lsb-release --yes
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
apt update
apt install nginx=1.14.2* --yes

cp /etc/nginx/nginx.conf /etc/nginx/nginxbckp.conf
mkdir /etc/nginx/sites-available/ /etc/nginx/sites-enabled/
sed -i '/http {/a include /etc/nginx/sites-enabled/*.conf;' /etc/nginx/nginx.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
service nginx restart

curl 127.0.0.1 |  grep -om 1 "Welcome to nginx"

pspid=$(ps -lfC nginx | grep master | awk '{print $4}');
#filepid=$(cat /var/run/nginx.pid);
echo -e "Nginx main process have a PID: \033[37;1;41m $pspid \033[0m";

cntpsw=$(ps -lfC nginx | grep worker | wc -l) 
echo -e "Count of worker process : \033[37;1;41m $cntpsw \033[0m";
