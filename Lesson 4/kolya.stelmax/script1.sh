#!/bin/bash

if [[ "$EUID" -ne 0 ]];
 then
  echo "Please run script as root"
  exit
fi


apt-get remove docker docker-engine docker.io containerd runc
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt-get install -y docker-ce docker-ce-cli containerd.io
adduser --disabled-password --gecos "" sailor
usermod -aG docker sailor
su -  sailor -c 'docker run --rm -it ubuntu:16.04 bash'

