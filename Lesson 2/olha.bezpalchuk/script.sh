#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo 'Please run as root'
  exit
fi

function debugMessage() {
  echo -e '\e[32m>' $1 '\e[39m'
}

# 1. Show list of installed programs and check if nginx is in there
debugMessage '\t===== task 1 ====='
debugMessage 'checking for nginx...'
if dpkg -l | grep nginx > /dev/null 2>&1;
then
  # 1.1 If yes, uninstall nginx and show message about deleting. Specify uninstalled version.
  debugMessage 'nginx found'
  VERSION="$(nginx -v)"
  debugMessage "uninstalling nginx version ${VERSION}..."
  apt-get -y purge nginx nginx-common
  apt-get -y autoremove
  debugMessage "> nginx uninstalling - done (version ${VERSION})"
else
  # 1.2 If no, show message about not being installed
  debugMessage 'nginx not found'
fi

#2 Add nginx remote repository (using documentation) and install nginx 1.14.2
debugMessage '\t===== task 2 ====='
debugMessage 'installing nginx 1.14.2...'
# install the prerequisites
apt-get -y install curl gnupg2 ca-certificates lsb-release
# set up the apt repository for stable nginx packages
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
# import an official nginx signing key so apt could verify the packages authenticity
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
# verify key
apt-key fingerprint ABF5BD827BD9BF62
apt-get -y update
# apt-get -y install nginx=1.14.2-1~xenial
apt-get -y install nginx=1.14.2-1~bionic
debugMessage 'installing nginx 1.14.2 - done'
nginx -v

# 2.1 add directories sites-available and sites-enabled in nginx config folder. Add sites-enabled to nginx.conf
debugMessage 'adding directories...'
mkdir /etc/nginx/conf.d/sites-available
mkdir /etc/nginx/conf.d/sites-enabled
debugMessage 'adding directories - done'
debugMessage 'adding sites-enabled to nginx.conf...'
cat /etc/nginx/nginx.conf | sed '/include.*conf/ a \ \ \ \ include /etc/nginx/conf.d/sites-enabled/*;' > nginx.tmp
cat nginx.tmp > /etc/nginx/nginx.conf
rm nginx.tmp
debugMessage 'adding sites-enabled to nginx.conf - done'

# 2.2 move default.conf file to sites-available and make symlink to sites-enabled. Restart nginx.
debugMessage 'default configs....'
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/sites-available/default.conf
ln -s /etc/nginx/conf.d/sites-available/default.conf /etc/nginx/conf.d/sites-enabled/default.conf
service nginx restart
debugMessage 'default configs - done'

#2.3 make request to nginx and get Welcome to nginx message
curl -s 127.0.0.1 | grep -o 'Welcome to nginx' | head -1

#3 discover and show PID nginx master process. Do it using awk. Format result..
debugMessage '\t===== task 3 ====='
PID="$(ps aux | grep -i /nginx.*master/ | awk '{ print $2 }')"
echo "Nginx main process have a PID: ${PID}"

#3.1 show number of nginx worker processes. Use formatting as for p.3 plus red color
PID="$(ps aux | grep -c -i /nginx.*worker/ | awk '{ print $1 }')"
echo -e "\e[31mNumber of nginx worker processes: ${PID}\e[39m"
