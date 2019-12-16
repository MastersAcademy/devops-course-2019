#!/bin/bash

set -x
id=$(id -u);
#check if isn't sudo 
if [ "$id" -ne 0 ]
  then echo "Run this file by sudo";
  exit 0;
fi

apt-get update
apt-get remove docker docker-engine docker.io containerd runc
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get install docker-ce docker-ce-cli containerd.io -y
useradd sailor -G docker
passwd -d sailor
su - sailor bash -c 'docker run -it ubuntu:16.04 bash'
