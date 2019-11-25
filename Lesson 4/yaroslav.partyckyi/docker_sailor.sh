#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo ' . . . permission denied, please run as root'
    exit
fi

echo -e "\n . . . remove/install docker\n"

sudo apt-get update
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo -e "\n . . . sailor user\n"

adduser sailor --disabled-password
usermod -aG docker sailor
su - sailor bash -c 'docker run -it ubuntu:16.04 bash'