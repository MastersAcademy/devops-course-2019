#bo!/in/bash
if
    dpkg -l | grep nginx
then 
    ver=$(nginx -v 2>&1)
    sudo apt purge -y nginx nginx-common
    echo "Deleted $ver"
else
    echo "Not Installed"
fi


apt install -y  curl gnupg2 ca-certificates lsb-release
echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key
apt update
apt install nginx=1.14.2*


mkdir /etc/nginx/{sites-available,sites-enabled}
sed -i '/http {/a include /etc/nginx/sites-enabled/\*.conf;' /etc/nginx/nginx.conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
sudo service nginx restart
curl -X 127.0.0.1 | grep -o 'Welcome to nginx' | head -1

nginx_proc=$(ps -lfC nginx | grep "master process" | awk '{print $4}')
nginx_proc_count=$(ps -lfC nginx | grep -c "worker process")
echo "Nginx main process have a PID: $nginx_proc"
echo -e "Number of Nginx working processes: \033[31m$nginx_proc_count\e[0m"

