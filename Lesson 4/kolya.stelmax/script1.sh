#!/bin/bash

if [[ "$EUID" -ne 0 ]];
 then
  echo "Please run script as root"
  exit 
fi


sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
adduser sailor --disabled-password
sudo usermod -aG docker sailor
su -  sailor -c 'docker run --rm -it ubuntu:16.04'

