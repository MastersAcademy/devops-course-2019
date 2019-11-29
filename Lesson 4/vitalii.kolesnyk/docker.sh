#!/bin/bash
#set -x #отладка
# Задание 1
echo "Дратуті!"
if dpkg -l | grep ii | grep docker
then
        apt purge -y docker*
fi
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic st$
apt install docker-ce -y
useradd -G docker sailor
su - sailor -c 'docker run -it --rm ubuntu:16.04 bash'
