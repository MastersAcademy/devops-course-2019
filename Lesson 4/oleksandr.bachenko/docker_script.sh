#!/bin/bash

#remove docker
sudo apt-get remove docker docker-engine docker.io containerd runc

#install new repository
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#install docker engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#add user
sudo useradd sailor -G docker
sudo passwd -d sailor

su - sailor -c 'docker run -it ubuntu:16.04 bash'
