#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run script as root"
  exit 1	
fi

#1.1 remove docker
apt-get remove docker docker-engine docker.io containerd runc

#set up the repository
apt-get update
apt-get install -y apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#1.2 install docker ce
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

#1.3 add sailor user non-interactively
adduser --disabled-password --gecos "" sailor
usermod -aG docker sailor

#2
su - sailor -c 'docker run -it ubuntu:16.04 bash'
