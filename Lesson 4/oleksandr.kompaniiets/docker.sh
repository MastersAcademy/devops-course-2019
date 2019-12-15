#!/bin/bash


set -x

if [[ $(id -u) -ne 0 ]]; 
then
  echo "Please run script as root"
  exit 1
fi


apt-get purge -y docker*

apt-get autoremove

apt-get update

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io

adduser --disabled-password --gecos "" sailor
usermod -aG docker sailor

su - sailor -c 'docker run -it ubuntu:16.04 bash'
