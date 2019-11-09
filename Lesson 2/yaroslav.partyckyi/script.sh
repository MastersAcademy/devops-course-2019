#!/bin/bash

function checkNginx {
    echo -e "\n . . . nginx version:"
    nginx -v
}



echo -e "\n . . . running script"
echo -e "\n . . . list of programs:\n"

apt list --installed

if [[ `command -v nginx` ]]
then
    checkNginx

    echo -e "\n . . . nginx will be removed:\n"

    apt remove nginx nginx-common -y
    apt purge nginx nginx-common -y
    apt autoremove -y
    
    echo -e  "\n . . . nginx has been deleted\n"
else
    echo -e  "\n . . . nginx not found"
fi



echo -e "\n . . . installing nginx of version 1.14.2\n"

apt install -y curl gnupg2 ca-certificates lsb-release

echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
	| tee /etc/apt/sources.list.d/nginx.list 
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

apt-key fingerprint ABF5BD827BD9BF62
apt update
apt install nginx=1.14.2-1~disco

checkNginx

cd /etc/nginx/
mkdir sites-available/ sites-enabled/
mv nginx.conf tempo.nginx.conf
sed '/include \/etc\/nginx\/conf.d\/\*.conf;/a \\tinclude /etc/nginx/sites-enabled/\*.conf;' tempo.nginx.conf > nginx.conf
rm tempo.nginx.conf

mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/;
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/;

service nginx restart;

echo -e "\n"
curl 127.0.0.1 | grep -o "Welcome to nginx!"
echo -e "\n"



echo -e "\n . . . nginx processes:\n"
echo "Nginx main process have a PID: `ps -fC nginx | grep master | awk '{print $2}'`" 
echo -e "Nginx number of 'worker' processes: \e[1;31m`ps -fC nginx | grep -c worker`"

exit 0;
