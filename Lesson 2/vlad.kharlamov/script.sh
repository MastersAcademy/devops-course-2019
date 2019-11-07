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

rem_output=$(sudo apt remove -y nginx 2> /dev/null)

rem_version=`echo $rem_output|awk -F " " '/\([0-9].+[0-9]\)/{gsub(/[()]/,""); print ($(NF-1))}'`

echo Nginx removed version: $rem_version
else
echo Nginx not found
fi

sudo apt install -y curl gnupg2 ca-certificates lsb-release

echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

sudo apt update

sudo apt install -y  nginx=1.14.2*

nginx_work_dir=`nginx -t 2>&1 |awk 'NR==1{if($0 ~/nginx.conf/){gsub(/nginx.conf/,"");print $5}}'`
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
awk -v line="$editStringNum" -v text="$includeSA" 'NR==line {print text};{print}' /etc/nginx/nginx.conf > /etc/nginx/output
count="1"
else
echo '"sites-available" found'
fi

if [ -z "$sitesEnabled" ]
then
awk -v line="$editStringNum" -v text="$includeSE" 'NR==line+1 {print text};{print}' /etc/nginx/output > /etc/nginx/nginx.conf

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
rm /etc/nginx/output
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
