#!/bin/bash
#remove old docker
apt-get purge docker* -y
apt-get remove -y docker docker-engine docker.io containerd runc
rm -rf /var/lib/docker

#add community docker rep
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#install community docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

#docker autostart
systemctl enable docker

#add new user
useradd sailor -G docker
passwd -d sailor 

#run docker
su - sailor -c 'docker run -it ubuntu:16.04 bash'
