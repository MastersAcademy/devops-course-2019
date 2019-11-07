#!/bin/sh

version=`dpkg -l |grep 'ii\s\snginx\s' | awk '{print $3}'`

if [ -n "$version" ]
then

rem_output=$(sudo apt remove nginx 2> /dev/null <<EOF
Y
EOF
)

rem_version=`echo $rem_output|awk -F " " '/\([0-9].+[0-9]\)/{gsub(/[()]/,""); print ($(NF-1))}'`

echo Nginx removed version: $rem_version
else
echo Nginx not found
fi

sudo apt install curl gnupg2 ca-certificates lsb-release << EOF
Y
EOF

echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

sudo apt update

sudo apt install nginx=1.14.2* << EOF
Y
EOF

