#!/bin/bash


function updateData {
sitesAvailable=`cat /etc/nginx/nginx.conf|awk '/sites-available/{print $1}'`
sitesEnabled=`cat /etc/nginx/nginx.conf|awk '/sites-enabled/{print $1}'`
}

includeSA="    include /etc/nginx/sites-available/*.conf;"
includeSE="    include /etc/nginx/sites-enabled/*.conf;"

version=`dpkg -l |grep 'ii\s\snginx\s' | awk '{print $3}'`

if [ -n "$version" ]
then
echo "Nginx found. Do you want remove? [Y/n]"
read -s -n 1 nginxInstall
if [[ $nginxInstall =~ ^[Nn][Oo]* ]]
then
echo "Exited by user"
echo $nginxInstall
exit 0
else
echo  "Removing..."
fi

rem_output=$(sudo apt remove -y nginx 2> /dev/null)

rem_version=`echo $rem_output|awk -F " " '/\([0-9].+[0-9]\)/{gsub(/[()]/,""); print ($(NF-1))}'`

echo "$rem_output"
echo "Nginx removed version: $rem_version"
exit 0
else

echo -e "\e[31mNginx not found, do you want to install? [Y,n]\e[0m"
read -s -n 1 nginxInstall
if [[ $nginxInstall =~ ^[Nn][Oo]* ]]
then
echo "Exited by user"
echo $nginxInstall
exit 0
fi
fi


sudo apt install -y curl gnupg2 ca-certificates lsb-release

echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

sudo apt update

sudo apt install -y  nginx=1.14.2*

nginx_work_dir=`nginx -t 2>&1 |awk '{if($0 ~/nginx.conf/){gsub(/\/nginx.conf/,"");print $5;exit}}'`
nginx_dirs=`ls -d $nginx_work_dir*/`

if [ -d "$nginx_work_dir" ]
then
echo Dirs present: $nginx_dirs
mkdir {$nginx_work_dir/sites-enabled,$nginx_work_dir/sites-available}
else
echo Could not find nginx directory
fi


editStringNum=`cat $nginx_work_dir/nginx.conf|awk '/http {/{print NR+1}'`

updateData
if [ -z "$sitesAvailable" ]
then
awk -v line="$editStringNum" -v text="$includeSA" 'NR==line {print text};{print}' $nginx_work_dir/nginx.conf > /etc/nginx/output
count="1"
else
echo '"sites-available" found'
fi

if [ -z "$sitesEnabled" ]
then
awk -v line="$editStringNum" -v text="$includeSE" 'NR==line+1 {print text};{print}' $nginx_work_dir/output > /etc/nginx/nginx.conf

if [[ "$count" > "0" ]]
then
count=$((count++))
else
count="1"
fi

else
echo '"sites-enabled" found'
fi

updateData
if [[ "$count" > "0" ]]
then
if [ -n "$sitesAvailable" ]
then
rm $nginx_work_dir/output
if [ -n "$sitesEnabled" ]
then
echo "Include for nginx added"
else
echo "sites-available not found"
fi
else
echo "sites-enabled not found"
fi
fi

mv $nginx_work_dir/conf.d/default.conf $nginx_work_dir/sites-available/ 2> /dev/null

if [ ! -f $nginx_work_dir/sites-available/default.conf ]
then
echo -e "\e[31mNo file default.conf in $nginx_work_dir""/sites-available/\e[0m"
else
echo -e "\e[32mdefault.conf in $nginx_work_dir""/sites_available/\e[0m"
fi

ln -s $nginx_work_dir/sites-available/default.conf $nginx_work_dir/sites-enabled/default.conf 2> /dev/null

if [ ! -f $nginx_work_dir/sites-enabled/default.conf ]
then
echo -e "\e[31mNo link default.conf in $nginx_work_dir""/sites-enabled/\e[0m"
else 
echo -e "\e[32mLink default.conf in $nginx_work_dir""/sites-enabled/\e[0m"
fi

function nginxStart {
nginxStatus=`sudo service nginx status | awk '/running/{gsub(/[()]/,"");print $3}'`
nginxMainProcess=`sudo ps aux | awk '/nginx.conf$/{print $2}'`
}
nginxStart
echo $nginxStatus
echo $nginxMainProcess

if [ -n "$nginxStatus" ] && [ -n "$nginxMainProcess" ]
then
echo "Nginx main process have a PID: $nginxMainProcess"
else
echo "Nginx not running. Start? [Y/n]"
read -s -n 1 nginxStart

if [[ "$nginxStart"  =~ ^[Yy][Ee]* ]]
then
echo "Start the Nginx"
sudo service nginx start
nginxStart
if [ -n "$nginxStatus" ] && [ -n "$nginxMainProcess" ]
then
echo -e "\e[32mStarted\e[0m"
echo `curl  http://127.0.0.1 2> /dev/null |awk '/Welcome/{gsub(/[<]title[\/>]|[<][\/]title[>]/,"");print $1" "$2" "$3;exit}'`
echo "Nginx main process have a PID: $nginxMainProcess"
echo -e "Nginx PIDs: \e[31m"`sudo ps aux | grep  "master\|worker" | awk '/nginx/{print $2}'` "\e[0m"
else
echo "Nginx not started. Repair with you hands"
exit 1
fi
else 
echo "Exit"
fi

fi
