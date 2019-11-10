#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo 'Please run as root'
  exit
fi

# 1. Show list of installed programs and check if nginx is in there
echo '\t===== task 1 ====='
echo '> list of installed programs:'
dpkg -l
echo '> checking for nginx...'
if dpkg -l | grep nginx > /dev/null 2>&1;
then
  # 1.1 If yes, uninstall nginx and show message about deleting. Specify uninstalled version.
  echo '> nginx found'
  VERSION="$(nginx -v)"
  echo "> uninstalling nginx version ${VERSION}..."
  apt-get -y purge nginx nginx-common
  apt-get -y autoremove
  echo "> nginx uninstalling - complete (version ${VERSION})"
else
  # 1.2 If no, show message about not being installed
  echo '> nginx not found'
fi

#2 Add nginx remote repository (using documentation) and install nginx 1.14.2
echo '\t===== task 2 ====='
echo 'installing nginx 1.14.2...'
apt install curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
apt-key fingerprint ABF5BD827BD9BF62
apt-get -y update
apt-get -y install nginx=1.14.2-1~bionic
echo 'installing nginx 1.14.2 - done'
nginx -v

# 2.1 add directories sites-available and sites-enabled in nginx config folder. Add sites-enabled to nginx.conf
echo 'adding directories...'
mkdir /etc/nginx/conf.d/sites-available
mkdir /etc/nginx/conf.d/sites-enabled
echo 'adding directories - done'
echo 'adding sites-enabled to nginx.conf...'
sed '/include.*conf/ a \ \ \ \ \ \ \ \ include /etc/nginx/sites-enabled/*;' > nginx.conf1
cat nginx.tmp > nginx.conf
rm nginx.tmp
echo 'adding sites-enabled to nginx.conf - done'

# 2.2 move default.conf file to sites-available and make symlink to sites-enabled. Restart nginx.
echo 'default configs....'
cp /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/sites-available/default.conf
ln -s /etc/nginx/conf.d/sites-available/default.conf /etc/nginx/conf.d/sites-enabled/default.conf
service nginx restart
echo 'default configs - done'

#2.3 make request to nginx and get Welcome to nginx message
curl -s 127.0.0.1 | grep -o 'Welcome to nginx' | head -1


#3 discover and show PID nginx master process. Do it using awk. Format result..
#3.1 show number of nginx worker processes. Use formatting as for p.3 plus red color

